Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:1320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbYEBUdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:33:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1042654fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 13:33:08 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
Date: Fri, 2 May 2008 22:38:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805022141.28351.IvDoorn@gmail.com> <1209759116.3608.8.camel@johannes.berg>
In-Reply-To: <1209759116.3608.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805022238.21066.IvDoorn@gmail.com> (sfid-20080502_223251_721599_17FA687F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 May 2008, Johannes Berg wrote:
> 
> > Does anybody have any hint on where I should start looking about where
> > these frames come from, or what the cause might be of the disappearing frames?
> 
> What are the protection bits in the header? I'd have to look at the key
> selection code again I think. What about the ICV, are you adding that
> too at the end?

Now there you mention something. Looking at the Legacy driver, they only mention
ICV during the TX, but never during RX. I did find that the MMIC is appended at the
end of the frame, which is good, but they never do anything that looks like the
stripping of the ICV data...
So I assume it is stripped in the hardware, but no descriptor definition indicates
a ICV field like there is for IV and EIV. Unless.... they do have a 32bits "reserved" field
located directly after the IV/EIV fields.. makes one curious if that accidently contains ICV data. ;)

I'll add some debugging to dump more information about the header,
and what the contents is of that reserved field.

Thanks :)

Ivo
