Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:60376 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbYJNALi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 20:11:38 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Tue, 14 Oct 2008 02:15:47 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <1223941001.28019.3.camel@dv> <1223942439.28019.9.camel@dv>
In-Reply-To: <1223942439.28019.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810140215.47242.chunkeey@web.de> (sfid-20081014_021143_158338_E1D30362)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 October 2008 02:00:39 Pavel Roskin wrote:
> On Mon, 2008-10-13 at 19:36 -0400, Pavel Roskin wrote:
> 
> > p54_config() calls p54_set_freq(), which can fail with -EINVAL.  I'm
> > looking why it can happen.
> 
> The calibration table only has frequencies in the 2.4GHz band, but the
> scan goes through the 5GHz band as well.  That's how it fails:
> 
> freq = 5825
> i = 0, priv->iq_autocal[i].freq = 2412
> i = 1, priv->iq_autocal[i].freq = 2417
> i = 2, priv->iq_autocal[i].freq = 2422
> i = 3, priv->iq_autocal[i].freq = 2427
> i = 4, priv->iq_autocal[i].freq = 2432
> i = 5, priv->iq_autocal[i].freq = 2437
> i = 6, priv->iq_autocal[i].freq = 2442
> i = 7, priv->iq_autocal[i].freq = 2447
> i = 8, priv->iq_autocal[i].freq = 2452
> i = 9, priv->iq_autocal[i].freq = 2457
> i = 10, priv->iq_autocal[i].freq = 2462
> i = 11, priv->iq_autocal[i].freq = 2467
> i = 12, priv->iq_autocal[i].freq = 2472
> i = 13, priv->iq_autocal[i].freq = 2484
> phy9: frequency change failed
> ret = -22
> 
> Either we should be using a different table for the 5GHz band, or the
> driver should not announce 5GHz channels if the calibration table lacks
> them.
I ask again:
What Card/MAC & RF-Chip do you have? Indigo/Duette/Firsbee or XBow?

see switch instruction in p54common.c line 430 in p54_parse_eeprom

Regards,
	Chr
