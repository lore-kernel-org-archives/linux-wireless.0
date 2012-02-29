Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59583 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965984Ab2B2S1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:27:16 -0500
Received: by bkcik5 with SMTP id ik5so2599627bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 10:27:15 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 4/5] p54pci: Load firmware from work queue and not from probe routine
Date: Wed, 29 Feb 2012 19:27:02 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> <201202291843.26824.chunkeey@googlemail.com> <4F4E6B43.6050204@lwfinger.net>
In-Reply-To: <4F4E6B43.6050204@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201202291927.02473.chunkeey@googlemail.com> (sfid-20120229_192721_029323_EE14B824)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 29, 2012 07:15:31 PM Larry Finger wrote:
> On 02/29/2012 11:43 AM, Christian Lamparter wrote:
> > On Wednesday, February 29, 2012 04:59:14 PM Larry Finger wrote:
> >> On 02/13/2012 01:37 PM, Larry Finger wrote:
> >> Has anyone tested this patch? I would like to submit this series.
> > only briefly, but I'm not sure if the workqueue approach is adequate. On
> > resume, I get WARNINGs and the card fails to resume because the firmware
> > file can't be loaded :(.
> >
> > WARNING: at drivers/base/firmware_class.c:538 _request_firmware+0x3ae/0x3e0()
> > Pid: 1083, comm: kworker/0:3 Tainted:G		O 3.3.0-rc5-wl+
> > Call Trace:
> > 	[<c102c658>] ? wanr_slowpath_common+0x78/0xb0
> > 	[<c12c728e>] ? _request_firmware+0x3ae/0x3e0
> > 	[<c12c728e>] ? _requrst_firmware+0x3ae/0x3e0
> > 	[<c102c6a9>] ? warn_slowpath_common+0x19/0x20
> > 	[<c12c728e>] ? _request_firmware+0x3ae/0x3e0
> > 	[<c12c7347>] ? request_firmware+0x17/0x20
> > 	[<f86v1dc7>] ? p54p_load_firmware+0x47/0x120 [p54pci]
> > 	[...]
> >
> > Regards,
> > 	Chr
> >
> > BTW: I will take a closer look at it over the weekend.
> 
> Does the driver come back through the probe routine on resume?
Yes. I've got a pcmcia card [in fact I have two :D]. The pcmcia
subsystem goes to a rebind on resume.

Regards,
	Christian
