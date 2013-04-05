Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62889 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3DEI1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:27:15 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LcVHU-1V4HDj49dm-00jqJD for
 <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 10:27:14 +0200
Date: Fri, 5 Apr 2013 10:27:00 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <20130405082659.GA12495@blumentopf> (sfid-20130405_102721_697965_977AF788)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
 <20130403113554.GA14785@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com>
 <20130404205706.GA29851@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB6EC@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DDAB6EC@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Thu, Apr 04, 2013 at 03:56:28PM -0700, Bing Zhao wrote:
> > 
> > set 1:
> > 1/4 mwifiex: rework round robin scheduling of bss nodes.
> > 2/4 mwifiex: replace ra_list_curr by list rotation.
> > 3/4 mwifiex: bug: hold proper locks when accessing ra_list / bss_prio lists.
> > 4/4 mwifiex: bug: remove NO_PKT_PRIO_TID.
> 
> In your patchset 1, the actual patches are:
> 
> 1/4 mwifiex: bug: wrong list in list_empty check.
> 2/4 mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
> 3/4 mwifiex: bug: remove NO_PKT_PRIO_TID.
> 4/4 mwifiex: bug: hold proper locks when accessing ra_list / bss_prio lists.

thanks for fixing

> 
> And I have comments on 2/4 and 4/4. Could you please make changes and resend v3 series?
> Please let me know if you want me to make the change and post the v3.

thanks for fixing

> > set 2:
> > 1/2 mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
> > 2/2 mwifiex: bug: wrong list in list_empty check.
> 
> And the actual patchset 2 is:
> 
> 1/2 mwifiex: replace ra_list_curr by list rotation.
> 2/2 mwifiex: rework round robin scheduling of bss nodes.
> 
> checkpatch.pl detected a couple warnings. Please check and resend v3 series for patchset 2.

I get only one warning:

WARNING: networking block comments don't use an empty /* line, use /*
Comment...
#191: FILE: drivers/net/wireless/mwifiex/wmm.c:1011:
+
+/*

Probably this issue:

>From Documentation/CodingStyle:
----------------------------------------------------------------------
The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

For files in net/ and drivers/net/ the preferred style for long
(multi-line)
comments is a little different.

        /* The preferred comment style for files in net/ and drivers/net
         * looks like this.
         *
         * It is nearly the same as the generally preferred comment
         * style,
         * but there is no initial almost-blank line.
         */
----------------------------------------------------------------------

If I run: checkpatch.pl -f drivers/net/wireless/mwifiex/wmm.c. I
get about 10-20 similar warnings. In general it seems mwifiex
sticks with type 1 multiline comments. And I wanted to stick with
the de-facto standard.

Should I still fix the warning?
Should I prepare a separate patch on top fixing all multiline
comments?

> > 
> > Patch set 2 can be delayed, but since hard to read code probably
> > introduced all the problems, I suggest to apply it promptly.
> > It simplifies the code a lot.
> 
> I will ack your latest patchset 2 as soon as the WMM test is passed.
> 
> > > We will run stress tests against 4-6.
> > 
> > I'm here at 4+ days, still running. This exceeds all previous
> > tests on my particular setup.
> 
> Could you share what test cases you are running? I will try to cover the cases you have not done.

Duration test with high load, sender and receiver.

I have dualband router and two DUT. One DUT connects to
2.4GHz-band the other to 5GHz-band. One is running iperf as
server the other iperf as a client in a while true loop.

Eventually I will switch over to set one DUT as uAP, but didn't
play with uAP yet. 

rgds,
Andi
