Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE96C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 09:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51DA20666
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 09:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="jzXCax+e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C51DA20666
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbeLDJMZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 04:12:25 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:58746 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbeLDJMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 04:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=krwM61WLRI5ARp6Qm8+c5+IR/it2yTNAkAZ7eD2PAvk=;
        b=jzXCax+ezV2fov+dfS5o7q3cELFAw8bBefmqC711nc/6CrYANqFkKaadvffaL+pk6mMvjQ5EFiLjxvV2tllEYlZgQHH1quEJKOUMhJXDhtEIg6kL0QbxLevFQHcrF8U2QE44s2WivuPVhIKFgRz5WHqY6XCoKiq4t4209JlC0lE=;
Subject: Re: [PATCH v2 2/3] dt-bindings: net: ath10k: add new dt entry to
 identify external FEM
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
References: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
 <1543858415-23953-3-git-send-email-bperumal@codeaurora.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <d7d53ffb-9778-927c-5030-243c2ae57fcc@newmedia-net.de>
Date:   Tue, 4 Dec 2018 10:12:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <1543858415-23953-3-git-send-email-bperumal@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gU6kg-0003m3-Uq; Tue, 04 Dec 2018 10:12:22 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

you write that

"microsemi-lx5586", "sky85703-11" and "sky85803" is supported, but you just check for microsemi-lx5586
  in part 3

Am 03.12.2018 um 18:33 schrieb Bhagavathi Perumal S:
> This adds new dt entry ext-fem-name, it is used by ath10k driver
> to select correct timing parameters and configure it in target wifi hardware.
> The Front End Module(FEM) normally includes tx power amplifier(PA) and
> rx low noise amplifier(LNA). The default timing parameters like tx end to
> PA off timing values were fine tuned for internal FEM used in reference
> design. And these timing values can not be same if ODM modifies hardware
> design with different external FEM. This DT entry helps to choose correct
> timing values in driver if different external FEM hardware used.
>
> Signed-off-by: Bhagavathi Perumal S<bperumal@codeaurora.org>
> ---
>   Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index ef60f25..2dd0c52 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -61,8 +61,13 @@ Optional properties:
>   	Value type: <phandle>
>   	Definition: reference to the reserved-memory for the msa region
>   		    used by the wifi firmware running in Q6.
> +- ext-fem-name:
> +	Usage: Optional
> +	Value type: string
> +	Definition: Name of external front end module used. Valid FEM names are
> +		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc.
>   
> -Example (to supply the calibration data alone):
> +Example (to supply PCI based wifi block details):
>   
>   In this example, the node is defined as child node of the PCI controller.
>   
> @@ -77,6 +82,7 @@ pci {
>   		wifi@0,0 {
>   			reg = <0 0 0 0 0>;
>   			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
> +			ext-fem-name = "microsemi-lx5586";
>   		};
>   	};
>   };
> -- 1.9.1
