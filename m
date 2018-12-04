Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D6DC04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 11:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED01D20851
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 11:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TSuIbBRW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED01D20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbeLDLXZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:23:25 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42061 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbeLDLXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 06:23:23 -0500
Received: by mail-ot1-f67.google.com with SMTP id v23so14793053otk.9;
        Tue, 04 Dec 2018 03:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=8ZFyZqWQ4pfbOSy2KTFYeDzLuGBJJoylIyH6qRHzZUM=;
        b=TSuIbBRWBr3VfS0u5ZK8G9JiILJyIQdi+ryAk2X1VUcehtIno3qbdE8F75CQaSss7J
         zth0punD3qZqotWSlZYoARfM52MyCdxesuKUDM2N3K88AQf/rCqD6dGg1d0nQx5dQXd7
         AGD5v284hUMCCk2LwE1kFzaZQ+y9EW+marWSkMkcG/jCbDYaNKrq0qZ3rEhEfGfvG4N+
         IJycrE5PCD82P9G9a6L3Hp6Ii1CLePex9Zn4lnnZwfASs96tEEjF05Zky1JIH0fE0W+/
         N4MwpzcHq5vTywkezvLbwGfXGmZyrormvy5cG9ZDrpa48OT8WYpRBRo+VW2J2bTj0cjd
         4CqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=8ZFyZqWQ4pfbOSy2KTFYeDzLuGBJJoylIyH6qRHzZUM=;
        b=YNJZ4eW+BGpjJUMg2bxWg3UWMldbC5CeAB+XMQYelrfy5yJnCJ8oaOW0qgRD9Nhw39
         BsZUNKforWw28gfR6acJqqrc0kr2kcqqKb6HsNmrawOYYt2swVXgpHf4RzKzvNG9yDs+
         FWyTaud/HDIPo1ybqlXDHzs5E8fmmo5jbKIPDB+OVl0XyQ9vbwNssyQMEo2WCwuoEVUg
         CxztZBCVweDesEk10+IdxUemes1Iy5CES5w1V+7yIctvYZLF9ynOOjMPSWEQ4CVcML1H
         VSI5afKM1GPvxE2UuYsDuDmYcSxck0pVITQAnWcFxdXxKbhcocJdRKkRlu1rQOxC6pvT
         nH+g==
X-Gm-Message-State: AA+aEWYcJMIziDhtiMayGoDqFsPoL+l22fAkmwT23NE9e/+23gGOFT0m
        E0gv5U3nFukcjYhEY1MpP1QGzmRtfu9ixSzGPPc=
X-Google-Smtp-Source: AFSGD/WFsFZXOto/4jgVQCc8VM5VBK9NaLANjLrlzh7xEptOBeAFivAUdamgj1v729nw9iVTWii/B6Csp3/bWmDIBtw=
X-Received: by 2002:a9d:664f:: with SMTP id q15mr10118020otm.282.1543922602710;
 Tue, 04 Dec 2018 03:23:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Tue, 4 Dec 2018 03:23:22 -0800 (PST)
In-Reply-To: <d7d53ffb-9778-927c-5030-243c2ae57fcc@newmedia-net.de>
References: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
 <1543858415-23953-3-git-send-email-bperumal@codeaurora.org> <d7d53ffb-9778-927c-5030-243c2ae57fcc@newmedia-net.de>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 4 Dec 2018 12:23:22 +0100
Message-ID: <CAKR_QVKFx3oqb7cvyeY_+fKMxKA9PQkSDex-tvxrQcdc7hJ-CQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] dt-bindings: net: ath10k: add new dt entry to
 identify external FEM
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 04/12/2018, Sebastian Gottschall <s.gottschall@newmedia-net.de> wrote:
> Hi
>
> you write that
>
> "microsemi-lx5586", "sky85703-11" and "sky85803" is supported, but you just
> check for microsemi-lx5586
>   in part 3
>
> Am 03.12.2018 um 18:33 schrieb Bhagavathi Perumal S:
>> This adds new dt entry ext-fem-name, it is used by ath10k driver
>> to select correct timing parameters and configure it in target wifi
>> hardware.
>> The Front End Module(FEM) normally includes tx power amplifier(PA) and
>> rx low noise amplifier(LNA). The default timing parameters like tx end to
>> PA off timing values were fine tuned for internal FEM used in reference
>> design. And these timing values can not be same if ODM modifies hardware
>> design with different external FEM. This DT entry helps to choose correct
>> timing values in driver if different external FEM hardware used.
>>
>> Signed-off-by: Bhagavathi Perumal S<bperumal@codeaurora.org>
>> ---
>>   Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 8
>> +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index ef60f25..2dd0c52 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -61,8 +61,13 @@ Optional properties:
>>   	Value type: <phandle>
>>   	Definition: reference to the reserved-memory for the msa region
>>   		    used by the wifi firmware running in Q6.
>> +- ext-fem-name:
>> +	Usage: Optional
>> +	Value type: string
>> +	Definition: Name of external front end module used. Valid FEM names are
>> +		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc.
>>
>> -Example (to supply the calibration data alone):
>> +Example (to supply PCI based wifi block details):
>>
>>   In this example, the node is defined as child node of the PCI
>> controller.
>>
>> @@ -77,6 +82,7 @@ pci {
>>   		wifi@0,0 {
>>   			reg = <0 0 0 0 0>;
>>   			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
>> +			ext-fem-name = "microsemi-lx5586";
>>   		};
>>   	};
>>   };
>> -- 1.9.1
>

Sebastian might be right.

"Valid FEM names are
>> +		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc."

etc. inidicate you could put whatever here. where does the actual code
resides that manages different FEM ?
