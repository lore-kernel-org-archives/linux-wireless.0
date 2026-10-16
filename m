Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D61D265623
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135744; cv=none; b=Va9vCRPlPHUt/OFbS5xueaXkLkHSB10+WSufremyS/fOAAcptz+cmlkqamU0IJ0Eys+N42uTtiRv3NqPTn2IMzZ0M8yQvKNLiH2tw7m3CU28NhPcUbn9vcOuujXP9NibLuTFapMIWl5fdqxVy+01jKGz7cDIcPGsxvpGsnPrENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135744; c=relaxed/simple;
	bh=2PNs0/JTKH++fD5LGxSNo9xYfvMRk+RTVI7tAgip4os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJoLPARTwT0gUto2uWiMaDxkMtaUelJtJqX99h5ZWUqjtiX0EHVzXARaBHp6UItXfuYasj0WUoGxfbdLk+qXRhR6kfMqaNJyRrLtrV4+HwTqRTjevLh5oh3jBo3RMlmFKt3Iz11Oe+Nmif1YGIrPVtg1im5fdO9c+1U+w7ZYLL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=e9HsZykP; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="e9HsZykP"
Received: (wp-smtpd smtp.wp.pl 14326 invoked from network); 16 Oct 2026 09:28:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792135731; bh=Q2c5wUfdYRLbvGFPLmBXec3IbXd2WfNLzyPvBRVsFKo=;
          h=From:To:Cc:Subject;
          b=e9HsZykP0EDdokXLRABB02u2I+Ua51WVbxqJn8LrSGVYTF8BiEwQmAJnLB+dd2t9p
           IxtZg6poXrQZScRyaMSA1TIU12cILgyPz0RcXwh6x5le4nimPRgBFK+ZoveJK/unP5
           Ezkr/CjkKhTSRxnLtZGU6ysw0ejJ9cvHqsaO7wVhg8JA+LWAHGLtuJIod4b5uNcZzf
           GFaEzls1Ho0JV+VcE/srlPh/WjLADWSGv/lwx2xxtS7c9SN3BOFumIAP6SSfVsLU2k
           ihjmput75zkiU72yv2ifSbhUbXuIu8NdbBxCTOdUCZLh91PIph4tAM8mrvDwukfQ+r
           h6E+wWeO7xyTg==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <thy15333007817@163.com>; 16 Oct 2026 09:28:51 +0200
Date: Fri, 16 Oct 2026 09:28:51 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Heyang Tan <thy15333007817@163.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rt2x00: rt61pci: trim RX skb to reported frame
 length
Message-ID: <20261016072851.GA70242@wp.pl>
References: <20261016035706.1706-1-thy15333007817@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016035706.1706-1-thy15333007817@163.com>
X-WP-MailID: 2d36ecea3ca5c4d72ee381dbe4a9984b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [UUOh]                               

On Fri, Oct 16, 2026 at 11:57:06AM +0800, Heyang Tan wrote:
> rt61pci_fill_rxdone() reports rxdesc.size from the 12-bit
> DATABYTE_COUNT field but, unlike the USB drivers, does not trim the skb
> to that length.  rt2x00lib_rxdone() then computes the 802.11 header
> length from the untrimmed skb and can call rt2x00crypto_rx_insert_iv()
> while skb->len does not match rxdesc.size.
>
> Trim the skb at the end of rt61pci_fill_rxdone(), matching rt2500usb and
> rt73usb, so the skb length is correct before the header length is
> computed and before any IV/ICV data is reinserted.
>
> Signed-off-by: Heyang Tan <thy15333007817@163.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt61pci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> index d4783658b..b2ee0cc14 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> @@ -2051,6 +2051,14 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
>  		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
>  	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
>  		rxdesc->dev_flags |= RXDONE_MY_BSS;
> +
> +	/*
> +	 * Trim the skb to the reported frame length.  rt2x00lib_rxdone()
> +	 * computes the 802.11 header length from the skb before calling
> +	 * rt2x00crypto_rx_insert_iv(), and that function requires skb->len
> +	 * to match rxdesc.size.
> +	 */
We don't need this comment IMHO.
> +	skb_trim(entry->skb, rxdesc->size);

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Regards
Stanislaw
