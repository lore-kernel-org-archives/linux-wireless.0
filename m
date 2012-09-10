Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63539 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2IJP7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 11:59:24 -0400
Received: by eekc1 with SMTP id c1so1282683eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 08:59:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: [PATCH v3] p54: connect to 11w protected networks
Date: Mon, 10 Sep 2012 17:59:17 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <E1TA0re-00059m-CD@debian64.localnet> <1347036664.8913.1.camel@dcbw.foobar.com> <87ehma5agf.fsf@purkki.adurom.net>
In-Reply-To: <87ehma5agf.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201209101759.17751.chunkeey@googlemail.com> (sfid-20120910_175928_286926_CB0DC75F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 September 2012 14:28:00 Kalle Valo wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> > On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
> >> Previously, it was not possible to connect
> >> to networks which requires 11w to be supported
> >> by the stations.
> >
> > If at all possible if we can do this without module parameters, that
> > would be great.  Otherwise how is userspace supposed to connect to a
> > W-capable network without twiddling driver-specific module options,
> > something we've tried really hard to not do?  Module options really
> > aren't any different than private ioctls or IWPRIV commands...
> 
> Sure, and that's how it works with properly supported hardware. But p54
> is so old that the user will need to buy newer hardware if he really
> needs 11w support out-of-box. IMHO there's no point of making a huge
> effort to add 11w support to older hardware, there are more important
> things to fix in Linux wireless stack than that.

Dan's concern has been addressed by v4 of this patch
(which depends on johannes' "add mgmt key flags" patch).
p54 should now provide basic support for 11w protected
networks w/o messing with any module parameters.

Regards,
	Chr 
