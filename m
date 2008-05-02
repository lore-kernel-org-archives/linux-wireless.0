Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:54763 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934078AbYEBUyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:54:12 -0400
Received: by nf-out-0910.google.com with SMTP id d3so768643nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 13:54:07 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
Date: Fri, 2 May 2008 22:59:19 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805022141.28351.IvDoorn@gmail.com> <200805022238.21066.IvDoorn@gmail.com> <1209760939.3608.20.camel@johannes.berg>
In-Reply-To: <1209760939.3608.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805022259.20118.IvDoorn@gmail.com> (sfid-20080502_225349_339283_BF208D68)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 May 2008, Johannes Berg wrote:
> 
> > Now there you mention something. Looking at the Legacy driver, they only mention
> > ICV during the TX, but never during RX. I did find that the MMIC is appended at the
> > end of the frame, which is good, but they never do anything that looks like the
> > stripping of the ICV data...
> > So I assume it is stripped in the hardware, but no descriptor definition indicates
> > a ICV field like there is for IV and EIV. Unless.... they do have a 32bits "reserved" field
> > located directly after the IV/EIV fields.. makes one curious if that accidently contains ICV data. ;)
> 
> Heh. Maybe the hardware actually does replay protection so it doesn't
> matter?

The comments in the legacy driver indicates the IV/EIV data was provided for replay attack checking,
and I do see a lot of ReplayCounters being memcpy'ed and memcmp() in the driver.
What is missing is the intialization of those counters to anything other then 0, and
the actual usage of the IV/EIV data in the Rx descriptor. ;)

Ivo
