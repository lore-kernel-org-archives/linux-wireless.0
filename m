Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56352 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab3DOFkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 01:40:45 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Peter Wells <peterwells723@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"iwl@linux.intel.com" <iwl@linux.intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: [Ilw] iwlwifi architecture question
Date: Mon, 15 Apr 2013 05:40:39 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30196DB7E@HASMSX103.ger.corp.intel.com> (sfid-20130415_074050_358036_2632A17E)
References: <1365971983.80784.YahooMailNeo@web164901.mail.bf1.yahoo.com>
In-Reply-To: <1365971983.80784.YahooMailNeo@web164901.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>I am beginning to work with the iwlwifi driver and was wondering if there was a document available to show the overall architecture of the driver? How the different components operate with each other and possibly how it interacts with the mac80211 module. Any assistance related to >how packets are routed to/from the underlying microcode would be helpful. Thank you in advance!

You can look at iwl-trans.h and iwl-op-mode.h. This will explain the interactions between the transport layer and the op_mode. The transport layer is in charge of bus related activities such as DMA, Tx rings, interrupt handling etc... but isn't fw API dependent. The transport layer doesn't know anything about mac80211 nor the fw. The op_mode (which stands for operation mode) is the part that handles fw API on one hand, and mac80211 API on the other hand. You can look at mac80211.c to see the mac80211 API implementation. The op_mode uses the transport layer to handle all the bus related activities.
In terms of directory structure:
drivers/net/wireless/iwlwifi: files that are generic to op_mode / transport + API definition (iwl-trans.h and iwl-op-mode.h).
drivers/net/wireless/iwlwifi/dvm: the op_mode for all NICs currently available.
drivers/net/wireless/iwlwifi/mvm: the op_mode for the new fw API that will be available with the next NIC to be launched (7000 family)
drivers/net/wireless/iwlwifi/pcie: the PCI implementation of the transport layer. This is the only one available right now.

We use the request_module API which is quite uncommon, so the init flow is a bit complicated but I am not sure you need that at that point. I think the code is fairly documented, so I am pretty sure you won't get lost.

You can also paste the text below to www.websequencediagrams.com. I wrote that long ago, and it is probably not 100% accurate, but it can give a few hints to someone who looks at the source for the first time.
My turn to ask questions - what do you intend to use iwlwifi for?
When will we see patches? :-)

=====
participant OS
participant LTM
participant trans
participant op_mode
participant mac80211
participant fw_store

OS->LTM: module_init
note over LTM
    registration
    to bus driver
end note

note over LTM
    This code is
    bus specific
end note

LTM-->OS:

OS->trans: probe
note over trans: allocation
activate trans

trans->LTM: start(trans_ops)
activate LTM

note over LTM:
    allocate LTM
    (struct fw, enum op_mode)
end note

note over LTM: request_fw

LTM->fw_store: init(blob)
activate fw_store
note over fw_store: check file format, parsing
fw_store-->LTM: pointers to sections, caps, ...

note over LTM:
    determine what
    .ko to load
    legacy / next-gen
end note

alt legacy
    LTM->op_mode: request_module(legacy)

else next-gen

    LTM->op_mode: request_module(next_gen)
    note right of LTM: 
       what op_mode
       to load ?
    end note

end

     LTM->op_mode: init(&trans_ops)
     activate op_mode
        op_mode->trans: start_hw
        trans-->op_mode:
        op_mode->trans: start_fw(INIT pieces)
        note over trans: loads the fw and\nkicks the NIC
        trans-->op_mode:

note over op_mode: wait for alive

NIC-->op_mode: alive Rx

note over op_mode
the following is run in
the context of start
and not in Rx context
end note

op_mode->trans: fw_alive
note over trans: enable ICT\nstart Tx
trans-->op_mode:

note over op_mode trans NIC:
run calib / NVM ...
end note

op_mode->NVM: init

NVM->trans: get NVM
trans-->NVM:
NVM-->op_mode:

     op_mode->mac80211: alloc_hw(sizeof(\nop_mode / legacy))
     activate mac80211
     mac80211-->op_mode:
     op_mode-->LTM:

     LTM->op_mode: start_operation
      note over op_mode
         iwl_probe besides
         request_fw
      end note
      op_mode->mac80211: register_hw
      mac80211-->op_mode:
      op_mode-->LTM:

LTM-->OS:
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

