Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:36073 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab2LRQC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 11:02:56 -0500
Message-ID: <50D093AC.9020501@neratec.com> (sfid-20121218_170300_289478_90E4C0E6)
Date: Tue, 18 Dec 2012 17:02:52 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	adrian@freebsd.org, nbd@openwrt.org, jonbither@gmail.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de> <20121213140753.GA26868@pandem0nium> <50D04EC9.2040805@neratec.com> <20121218134611.GA7053@pandem0nium>
In-Reply-To: <20121218134611.GA7053@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2012 02:46 PM, Simon Wunderlich wrote:
> [...]
> 
> Yes, that helped very much, especially the varying data part was something I had no
> clue about. This might also fix the "weird high numbers in the middle of the dump"
> problem I was seeing.
> 
If you mean the bin at center frequency, it is because spectral is blind there. To
remove discontinuity, that bin is interpolated, see line
+	// DC value is invalid -> interpolate
+	*dc_pwr = (dc_pwr[-1] + dc_pwr[1]) / 2;

> I'll change the patch according to your explanations, so that only 56 byte data samples
> are returned (at least for HT20).
> 
> Thank you very much!
> 	Simon
> 

Good luck!
Zefir
