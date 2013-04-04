Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58074 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761195Ab3DDW4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 18:56:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 4 Apr 2013 15:56:28 -0700
Subject: RE: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB6EC@SC-VEXCH1.marvell.com> (sfid-20130405_005642_262993_30BFD85E)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
 <20130403113554.GA14785@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com>
 <20130404205706.GA29851@blumentopf>
In-Reply-To: <20130404205706.GA29851@blumentopf>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

> I reworked the patchset and split into two.

Thanks for the v2 series.

> 
> 
> set 1:
> 1/4 mwifiex: rework round robin scheduling of bss nodes.
> 2/4 mwifiex: replace ra_list_curr by list rotation.
> 3/4 mwifiex: bug: hold proper locks when accessing ra_list / bss_prio lists.
> 4/4 mwifiex: bug: remove NO_PKT_PRIO_TID.

In your patchset 1, the actual patches are:

1/4 mwifiex: bug: wrong list in list_empty check.
2/4 mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
3/4 mwifiex: bug: remove NO_PKT_PRIO_TID.
4/4 mwifiex: bug: hold proper locks when accessing ra_list / bss_prio lists.

And I have comments on 2/4 and 4/4. Could you please make changes and resend v3 series?
Please let me know if you want me to make the change and post the v3.

[...]

> set 2:
> 1/2 mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
> 2/2 mwifiex: bug: wrong list in list_empty check.

And the actual patchset 2 is:

1/2 mwifiex: replace ra_list_curr by list rotation.
2/2 mwifiex: rework round robin scheduling of bss nodes.

checkpatch.pl detected a couple warnings. Please check and resend v3 series for patchset 2.

> 
> Patch set 2 can be delayed, but since hard to read code probably
> introduced all the problems, I suggest to apply it promptly.
> It simplifies the code a lot.

I will ack your latest patchset 2 as soon as the WMM test is passed.

> > We will run stress tests against 4-6.
> 
> I'm here at 4+ days, still running. This exceeds all previous
> tests on my particular setup.

Could you share what test cases you are running? I will try to cover the cases you have not done.

Thanks,
Bing
