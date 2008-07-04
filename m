Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:10517 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYGDK4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 06:56:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so355981nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 03:56:44 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Fri, 4 Jul 2008 13:02:44 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg>
In-Reply-To: <1214907990.7763.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807041302.44288.IvDoorn@gmail.com> (sfid-20080704_125649_829692_27873090)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Is there any way to get rt61 to report the receive timestamp? That would
> be very useful for monitor mode and good for IBSS.

I just received an answer from Ralink about this issue,

---
1.       For 11b/g based chips rt2500, rt2570, rt61, rt73 doesn't implement this.

2.       For 11n based chips, there is one MAC register have to enable to have this feature.
	  But, Word 2 of RXWI will put the timestamp and the RSSI will put to Word 3.
	 The original Word 3 SNR will disappear and replace by RSSI.
---

As for the timestamps in 2400 and rt2800, they are both in 32bits, so I am not sure how
reliable they will be for IBSS.

Ivo
