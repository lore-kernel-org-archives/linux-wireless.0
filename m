Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793351425;
	b=bhqKHiFmUKO/92FvsggNeAmkUnsOWQ0Uu5IzmlotxZM//PvPYaNQ3TQXA2KKMFV6ftL4
	 EMFMWE+BvbWsVkMQXunqvHjmNa3RUL7fCV7b7ieNMRkPRPtuQiwaakZa8Gw7cd1dME0VE
	 Lxj4StZ0ibqnlRm2fEPbFWmvkXdmv8aQVXqFfTuA2dkVfSy5/bTPf4poXXOVuWafL167P
	 ew5bjioRkPIap+erqdFayjb+aIMXY8YuGbzPA0FeJnsvQbGnPFh4snuSQc5Rck6e4D3sr
	 5C9tWcd/nZs4K+7KGVYufQXnnqHv9FZyc/0fbSPYFzDA6ILSdf6l/OYo+mG1JY1kSlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793351425;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=4hgR5T0jPLaVaLkO/iArq9dix1LSfTZRwSEApEKRMCI=;
	b=HINbyVUFcp6XJXt4qKCsBmMniE+mYZdEqMvoKcy2W6nWEO3baLpcjfFp5dvQCAfXOdCS
	 8rH+YNx3KpjKWCPwDfDoSNnkZiZUX/xnRwTIyfwvSIoCkh4wH39k1uTqYzS6Uhw6r25Bh
	 K0aj3DO5zSTGfd5Rug3f5ND7ZJ2+TfWm4NsrGsHSvLYE1TkctxaT91PsRc1D1og+1Ol96
	 Dk7k5iQu5e/0Q6gqkppgssfm4ItA8zoruXOIO532CThbqHloERBMarmr9RtrIdGLhrqxW
	 Y2DkVq1TkT60SxlsAwyOMIrmYlYrf0GWxg2HLEtUwUz8teKptp1JNZ6cKOxVeInPv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=L4qYkkRw;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0BB606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D0BB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=L4qYkkRw
Received: (wp-smtpd smtp.wp.pl 15358 invoked from network); 30 Oct 2026 10:10:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793351421; bh=4hgR5T0jPLaVaLkO/iArq9dix1LSfTZRwSEApEKRMCI=;
          h=From:To:Cc:Subject;
          b=L4qYkkRw2NmgiQVGZOEC0FKeX3Mypf/5MDUl+bZKtG4jDFmri8b7JSdvrU4Uhu0UU
           nJfkQZXpyh7K7OMg7aBaHqrhxT1j+TsM1iJaO0RQCQfyK0Mbhhtqtw77xzexLakmOK
           5Xvf23SdqyOKIpevrT4in348Z3h3M4fNmCdSW6mfptiS+C1jgMeCOCmnJG9e2B/EZT
           6csVVJhuBoV03bAnGRB2xuSH8IO8Ubt/PrYq10Svf3FmLK5/OzSYvHkd9Ft0ljTfOr
           hbuBNNN9EcWahAwIaPaKMKftJ7yDeWyAGdwxLzPU5rlbymwarXv8WTcMWXm5hHep3C
           lkzq2mkiNynKQ==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 30 Oct 2026 10:10:21 +0100
Date: Fri, 30 Oct 2026 10:10:20 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next 0/8] wifi: rt2x00: improve the throughput
 of rt2800usb
Message-ID: <20261030091020.GA27096@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
X-WP-MailID: f134606cdd34bfe0524bc0c49f2019f8
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [MXMB]                               

On Thu, Oct 29, 2026 at 09:47:41PM +0800, Ho Jie Feng wrote:
> This series improves the throughput of rt2800usb.
> 
> Implements
> - Frequency offset calibration
> - Better fallback rates
> - Aggregation
> - GRO
> 
> Tested on WNDA4100 RT3593, 5 GHz with perf3
> 
>   patch                          before        after
>                                  TX    RX      TX    RX
>   2 crystal calibration          27.7  31.6    28.5  69.7
>   4 MCS16 to MCS8 TX status      27.0  70.0    29.4  70.0
>   7 RX bulk aggregation          30.5  67.8    30.5  80.9
>   8 threaded NAPI with GRO       30.5  80.9    30.5  161.7

Nice work! On what host hardware did you take the measurements,
PC laptop/desktop or some embedded board ?

Regards
Stanislaw

> RT3070 did not have any visible change for both TX and RX.
> 
> Ho Jie Feng (8):
>   wifi: rt2x00: start the link tuner when an interface is added
>   wifi: rt2800: calibrate the crystal of RT3593 with the beacons
>   wifi: rt2800: use the 3SS fallback table of RT3883 on RT3593
>   wifi: rt2800: report the MCS16 to MCS8 fallback of RT3593 in TX status
>   wifi: rt2800: don't report an A-MPDU length to minstrel_ht
>   wifi: rt2800: set the mac80211 fast-xmit and aggregation flags
>   wifi: rt2800usb: enable RX bulk aggregation
>   wifi: rt2x00usb: use a threaded NAPI with GRO for RX
> 
>  drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
>  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 115 +++++++++++++++++-
>  .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
>  .../net/wireless/ralink/rt2x00/rt2800usb.c    |  33 ++++-
>  .../net/wireless/ralink/rt2x00/rt2800usb.h    |   6 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  16 ++-
>  .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 105 ++++++++++++----
>  .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
>  .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
>  .../net/wireless/ralink/rt2x00/rt2x00mac.c    |   6 +
>  .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |   2 +-
>  .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  52 ++++++--
>  12 files changed, 307 insertions(+), 44 deletions(-)
> 
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> -- 
> 2.53.0
> 
