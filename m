Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:61829 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3AIUBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 15:01:21 -0500
Received: by mail-bk0-f50.google.com with SMTP id jf3so1170654bkc.37
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 12:01:20 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
Date: Wed, 9 Jan 2013 21:01:16 +0100
Cc: Adrian Chadd <adrian@freebsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de> <201301091510.49723.chunkeey@googlemail.com> <20130109143304.GA23469@pandem0nium>
In-Reply-To: <20130109143304.GA23469@pandem0nium>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301092101.16435.chunkeey@googlemail.com> (sfid-20130109_210144_645028_236B4DC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Simon,

On Wednesday, January 09, 2013 03:33:04 PM Simon Wunderlich wrote:
> On Wed, Jan 09, 2013 at 03:10:49PM +0100, Christian Lamparter wrote:
> > On Wednesday, January 09, 2013 02:15:40 PM Simon Wunderlich wrote:
> > > On Tue, Jan 08, 2013 at 09:28:44AM -0800, Adrian Chadd wrote:
> > > > I still populate the WME fields; I need to "fix" paying attention to
> > > > them in the adhoc case.
> > > 
> > > Applying the EDCA parameters in the hardware and sending "standard" WME IEs
> > > (without EDCA parameter sets) is understandable, Linux does that too. 
> > 
> > Well, the WFA WMM Specification v1.2 costs $99 (last time I checked, which wasn't
> > too long ago). However Johannes told me that the WMM IE should not be added
> > to IBSS beacons.
> 
> I don't have the spec, and I don't intend to buy it. :)
> 
> But: We do have WMM IE sent by Linux IBSS STAs even today.
Ah, but I think you shouldn't ;).

> The difference to the AP WMM IEs is that it doesn't include EDCA parameters
> (cwmin/max, aifs, ...). But still, this is useful to detect that the other
> IBBS station is WMM-capable: we can then use QOS_DATA frames, use noack, etc ...
There's also the QoS Capability IE (8.4.2.37). It needs 3 bytes (one for the IE
ID, one for an IE LEN and then the QoS cap byte). But of course, the spec
doesn't say how it should be parsed for the IBSS case. 

Regards,
	Chr
