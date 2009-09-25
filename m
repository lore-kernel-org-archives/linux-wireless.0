Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:40817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbZIYSml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 14:42:41 -0400
Received: by fg-out-1718.google.com with SMTP id 22so250135fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 11:42:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problems with WPA in mainline 2.6.31-gitX
Date: Fri, 25 Sep 2009 20:42:37 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <4ABD0B0D.5020002@lwfinger.net>
In-Reply-To: <4ABD0B0D.5020002@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909252042.37881.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 September 2009 20:25:17 Larry Finger wrote:
> Johannes and John,
> 
> I found that commit bbac31f4 "cfg80211: fix SME connect" breaks WPA2
> connections. I found the problem using bisection. I verified the
> bisection by reverting the patch above. I also found that commit
> 55a00b833 "cfg80211: don't overwrite privacy setting" from
> wireless-testing fixed the issue.
> 
> Is the latter patch on its way upstream? If so, I will not bother with
> posting a regression on LKML or a bugzilla report. If not, I will
> initiate the formalities to ensure that the second patch is included
> in mainline.
> 

it made it into 2.6.31-git16:
"cfg80211: don't overwrite privacy setting"
94f85853324e02c3a32bc3101f090dc9a3f512b4

but, "[PATCH] cfg80211: don't set privacy w/o key"
is still missing.

Regards,
	Chr
