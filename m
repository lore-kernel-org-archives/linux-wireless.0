Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:14974 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYGWMzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 08:55:04 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2794252wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 05:55:04 -0700 (PDT)
Message-ID: <69e28c910807230555s2040f507oe6c9e516ef8c0685@mail.gmail.com> (sfid-20080723_145509_497551_0EFC50F5)
Date: Wed, 23 Jul 2008 14:55:03 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <4886C50E.6040304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br>
	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 7:43 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Johannes,
>
> In the current wireless-testing (v2.6.26-rc9-14207-ga520bdb), rtl8187 is
> broken. In most cases, it is unable to complete a connection. Occasionally,
> it will authenticate and even get an IP using DHCP; however, only a few
> pings get through to the AP before the connection fails completely.
>
> Using bisection, this problem was traced to:
>
> ==================================================
> commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Jul 10 11:21:26 2008 +0200
>
>    mac80211: fix TX sequence numbers
>
>    This patch makes mac80211 assign proper sequence numbers to
>    QoS-data frames. It also removes the old sequence number code
>    because we noticed that only the driver or hardware can assign
>    sequence numbers to non-QoS-data and especially management
>    frames in a race-free manner because beacons aren't passed
>    through mac80211's TX path.
> ===============================================================
>
> The validity of the bisection was confirmed by reverse application of the
> patch. The resulting driver worked.
>
> The appears that rtl8187 needs some kind of modification such as b43,
> b43legacy, and rt2x00 got in the original patch. I'll be studying the
> changes to the other drivers to see if I can find the problem, but I will
> appreciate your help when you get a chance. Perhaps after your trip to
> Canada is over.
>
> Thanks,
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Zd1211rw also appears to be affected, though not as seriously as with
rtl8187: it scans, associates and gets DHCP, but it consistently
disconnects after about 2~5 minutes, either with "No ProbeResp" in
dmesg, or sometimes with no error message, just "Removed STA" and
"Destroyed STA". I don't know if this is the same bug, as I haven't
bisected, but it appeared when I switched from a 2.6.26-rc8-wl kernel
to a 2.6.26-wl one that contained the above patch.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
