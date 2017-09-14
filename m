Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50230 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdINRut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 13:50:49 -0400
Message-ID: <1505411442.31630.11.camel@sipsolutions.net> (sfid-20170914_195052_153071_66BB528F)
Subject: Re: iwlwifi firmware load broken in current -git
From: Johannes Berg <johannes@sipsolutions.net>
To: Srinath Mannam <srinath.mannam@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Luca Coelho <luca@coelho.fi>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Thu, 14 Sep 2017 19:50:42 +0200
In-Reply-To: <CABe79T5fzTthk=c9891iT-_pQrNGaf+THzyi-B7cdqghX15Vug@mail.gmail.com> (sfid-20170914_194402_921163_AF6959E0)
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
         <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
         <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
         <1505246657.1974.11.camel@sipsolutions.net>
         <feabbc25-eb85-ffa2-0fd6-254c07e3574b@kernel.dk>
         <CAErSpo777jq9FVRtmoHXVbzE-ZOc7mnT+eRJ_PhP_Dd=MbKv4g@mail.gmail.com>
         <e7af2f85-0ab3-e524-a544-c2ccdf4f8bd6@kernel.dk>
         <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
         <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
         <CABe79T5fzTthk=c9891iT-_pQrNGaf+THzyi-B7cdqghX15Vug@mail.gmail.com>
         (sfid-20170914_194402_921163_AF6959E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 23:14 +0530, Srinath Mannam wrote:
> 
> atomic_inc_return(&dev->enable_cnt) in function
> pci_enable_device_flags enables passed pcie device.
> !pci_is_enabled(bridge) check in "if (bridge &&
> !pci_is_enabled(bridge))"  checks for bridge device of previous pcie
> device.
> So it will not stop bus_master of bridge device.

It also doesn't *enable* it though, does it?

johannes
