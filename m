Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:43923 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab2ATHcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 02:32:15 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Ro8xJ-0001U3-F8
	for linux-wireless@vger.kernel.org; Fri, 20 Jan 2012 08:32:13 +0100
Received: from localhost ([::1]:40606 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Ro8xJ-0004Mq-BN
	for linux-wireless@vger.kernel.org; Fri, 20 Jan 2012 08:32:13 +0100
Received: from [195.4.92.23] (port=47524 helo=13.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Ro8vK-00030f-K5
	for linux-wireless@vger.kernel.org; Fri, 20 Jan 2012 08:30:10 +0100
Received: from [2002:4fde:93e:2:5054:ff:feb8:40bd] (port=46194 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Ro8vK-0001Wx-3s
	for linux-wireless@vger.kernel.org; Fri, 20 Jan 2012 08:30:10 +0100
Message-Id: <201201200730.q0K7U0oj004966@mail.maya.org> (sfid-20120120_083239_320833_5FB5283D)
Date: Fri, 20 Jan 2012 08:29:57 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site> <4F0562DF.3000200@dualc.maya.org> <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com> <4F0AEBAB.9020104@01019freenet.de> <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com> <201201100803.q0A83nsQ003757@mail.maya.org> <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Hartmann schrieb:
> Hello Helmut,
> 
> Am Tue, 10 Jan 2012 10:50:16 +0100
> schrieb Helmut Schaa <helmut.schaa@googlemail.com>:
> 
>> On Tue, Jan 10, 2012 at 9:03 AM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
> [...]
>>> Looks as if sending of any package is reported as broken at some
>>> point of time and this circle cannot be left anymore.
>>
>> Not necessarily since mac80211 will only retry the BAR if a data frame
>> transmission was successful. Hence, it seems as if only the BARs TX
>> status is reported incorrectly ...
>>
>> I see two issues here:
>> 1) rt2800pci seems to have problems delivering the BAR _or_ doesn't
>>    report the tx status correctly
>> 2) If the same BAR fails consecutively we should maybe really tear down
>>    the BA session as it was done before
>>
>> 2 is done in the below untested patch and will also work around 1.
>> Mind to give it a try?
> 
> I encountered some temporary, short stalls during low bandwith
> (running X terminal sessions tunneled through ssh). Therefore I set 
> 
> 	MAX_BAR_RETRIES=0
> 
> This means, 
> 
> ieee80211_send_bar(&sta->sdata->vif, addr, tid,
> 		   tid_tx->failed_bar_ssn);
> 
> isn't called any more. But that's not all: the BA session isn't torn
> down any more, too - but it's working fine (high bandwith, too) anyway!?
> Why? (If I remove your patch again, the session completely stalls as
> ever).

Cool, this behaves completely other with ath9k-based STA. In the latter,
I'm "sometimes" getting entries like these in messages of the AP:

Jan 19 13:51:06 pc kernel: [17742.408040] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:51:19 pc kernel: [17755.342010] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:51:19 pc kernel: [17755.342013] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:51:19 pc kernel: [17755.342015] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:51:19 pc kernel: [17755.342016] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.271100] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.271106] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.271111] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.271114] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.271118] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.399106] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.399113] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.399117] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.399120] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:14 pc kernel: [17810.399124] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.581007] net_ratelimit: 3 callbacks suppressed
Jan 19 13:52:59 pc kernel: [17855.581011] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.581013] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.581016] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.581018] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.581020] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.582015] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.582018] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.582020] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.582022] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
Jan 19 13:52:59 pc kernel: [17855.582023] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames


nfs or streaming protocols aren't that happy with this situation. Iaw:
it's unusable.


All in one: Your workaround was a good idea, but unfortunately it
doesn't "solve" / workaround the problem introduced with the patch
"mac80211: retry sending failed BAR frames later instead of tearing
down aggr" [1]. I don't know off any other solution at this time as to revert it.

Do you have any idea how to fix the problem introduced with [1]?


Kind regards and thank you!
Andreas


[1] http://www.spinics.net/lists/linux-wireless/msg76379.html
