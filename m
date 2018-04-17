Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751204AbeDQTm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 15:42:59 -0400
Date: Tue, 17 Apr 2018 21:42:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kofi Agor <nenekofi@gmail.com>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180417194255.GA17067@redhat.com> (sfid-20180417_214303_748128_B3EF662A)
References: <20180326103551.GA2069@redhat.com>
 <24f8f4a2-b355-a1b3-d07a-940fc1e50fcc@kresin.me>
 <20180327171815.GA31338@redhat.com>
 <20180327174302.GB1206@makrotopia.org>
 <alpine.LNX.2.21.99.1803280605580.2911@mStation.localdomain>
 <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2018 at 07:32:57AM -0600, Kofi Agor wrote:
> Some minor changes to our patch:
> 
>    1. We (Craig Matsuura) found that disabling/enable the txtasklet worked
>    better than tearing down and recreating the txtasklet each time. It also
>    resolved a kernel oops we were experiencing.
>    2. Cleaned up the patch a bit and gave credit to the developers
>    3. There's a companion patch along with the txqueue patch that I forgot
>    to add when I submitted the txqueue patch the first time. It resolves an
>    rtnl deadlock during device unregistration. This should resolve the ifdown
>    issue you were experiencing.

I can see few problems with this patch (except that it's messy and hard
to read):
- it does not detect HW hung and does not reset the HW when needed
  as watchdog is supposed to do
- it waits only 100ms for TX status for each entry what is not enough,
  when then TX status will show up, we will get "Got TX status for an
  empty queue" error, but more importantly we do not feed rate control
  algorithm with proper data
- it push TX status to upper layers without filling it properly (what
  confuses rc algorithm even more) via rt2x00lib_txdone_nomatch()
  instead of rt2x00lib_txdone_noinfo(), which is intended for case when
  we have no status information.

Patch can help on situation when hardware do not provide TX status for each
sent frame, but there is much better way to handle this problem, see usb
version of the driver i.e. rt2800usb_work_txdone().

Cheers
Stanislaw
