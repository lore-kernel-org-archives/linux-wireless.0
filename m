Received: from mail.as201155.net (mail.as201155.net [185.84.6.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C526742DA5B
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.84.6.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784705395; cv=none; b=pIVy8Lwy2LRRZRZhScqbNmwmiJ7D5QyuqJvkUSIU+j3Z7388xfj6QGUPwJk1CnrRWWiXFA4eyKelzGSgEC3TbE2AcM3MjRXnClA7CuSsf4MW2zwKs9+VB46DhLfhyQxHwTC+DHDpNAetpWfazYEGehuWj92N7FHSpAObprhaOpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784705395; c=relaxed/simple;
	bh=YQ0M6aTs5mhws1ZTm81KbIaqhzL9vnGB/dEsh8jJVEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmTWtGhaWidi0lCvKbmstU4i+Vz3zd9d8Rr8CEdRxPc+H+m9mkNiZNefBEFMOX7sjrOYgkTOgqZOGAodV5BnqvNgIWBS+dT7IKcBn4f2t2DtZmb4Z7TbdetYojyc015oHzYrCfU0V0SMHMrqVNOyk+KY4nErME6BXQ5tAR7hCLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dd-wrt.com; spf=pass smtp.mailfrom=dd-wrt.com; dkim=pass (1024-bit key) header.d=dd-wrt.com header.i=@dd-wrt.com header.b=RdRiybVt; arc=none smtp.client-ip=185.84.6.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dd-wrt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dd-wrt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dd-wrt.com header.i=@dd-wrt.com header.b="RdRiybVt"
Received: from webmail.newmedia-net.de (smtps.newmedia-net.de [IPv6:2a05:a1c0:0:de::167])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.as201155.net (Postfix) with ESMTPS id 94C3ADFC62;
	Wed, 22 Jul 2026 09:20:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=aYPuVbYh7RG+NgL76jrvVCtnrENvIPOjy5CVFpCp0MI=;
	b=RdRiybVtdpLfNOFep2n4TSYrFjN6j7wHbIoYqBctOCXyHA4y9DCnvqgTABXTte7VW8eaVLpyR+V5jZGiJW7ZiJchUn83XRXwG2IohSCY4IIOGfGggXWwMxqgU4sGjbRwp0ZiX2eszf7n2xOD1bljGgT8gUH67qXigS0llBL+dOA=;
Message-ID: <9249a5ed-2da0-432b-a430-15bd5bb16215@dd-wrt.com>
Date: Wed, 22 Jul 2026 09:20:22 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH ath-next 0/6] wifi: ath12k: Add driver support for WDS
 mode
To: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
 ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260525110942.2890212-1-tamizh.raja@oss.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
In-Reply-To: <20260525110942.2890212-1-tamizh.raja@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Received-SPF: pass (webmail.newmedia-net.de: localhost is always allowed.) client-ip=127.0.0.1; envelope-from=s.gottschall@dd-wrt.com; helo=webmail.newmedia-net.de;
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: s.gottschall@dd-wrt.com
X-SA-Exim-Scanned: No (on webmail.newmedia-net.de); SAEximRunCond expanded to false
X-NMN-MailScanner-Information: Please contact the ISP for more information
X-NMN-MailScanner-ID: 1wmRFf-000D5l-Lp
X-NMN-MailScanner: Found to be clean
X-NMN-MailScanner-From: s.gottschall@dd-wrt.com
X-Received:  from localhost ([127.0.0.1] helo=webmail.newmedia-net.de)
	by webmail.newmedia-net.de with esmtp (Exim 4.72)
	(envelope-from <s.gottschall@dd-wrt.com>)
	id 1wmRFf-000D5l-Lp; Wed, 22 Jul 2026 09:20:23 +0200


Am 25.05.2026 um 13:09 schrieb Tamizh Chelvam Raja:
> This patch series introduces support for WDS in the driver by adding
>
> Handling of 4-address frame formats required for WDS operation.
> Proper setting of peer 4-address WMI param to ensure correct transmission
> and reception of multicast and unicast frames in WDS mode.
> Conversion of eth offload Rx frame to 802.11 frame for mac80211 to
> detect 4address frame and initiate AP_VLAN creation.
>
> Tamizh Chelvam Raja (6):
>    wifi: ath12k: Set WDS vdev parameter for 4-address station interface
>    wifi: ath12k: Add support for 4-address mode
>    wifi: ath12k: Add 4-address mode support for eth offload
>    wifi: ath12k: Add support for 4-address NULL frame handling
>    wifi: ath12k: Add support for 4-address frame notification
>    wifi: ath12k: Handle 4-address EAPOL frames from WBM error path
>
it should be mentioned that his feature only works with latest official 
WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1 firmware. i tested 1.7. series 
from qca networking tree and this firmware is missing the wds nullfunc 
service feature. so it seem that 1.6-01243 just added wds support and no 
other firmware will work with it.

regards, Sebastian Gottschall

