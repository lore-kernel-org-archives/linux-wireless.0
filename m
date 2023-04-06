Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CBBC77B6F
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Apr 2023 17:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbjDFRKD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Apr 2023 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFRKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2023 13:10:02 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EAB83F2;
        Thu,  6 Apr 2023 10:10:00 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id q27so28811513oiw.0;
        Thu, 06 Apr 2023 10:10:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680801000; x=1683393000;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aznOVjaPJTvuXKx1gmzX1wmBBoPOixwVKU/ceJyrGsk=;
        b=Vbr6Un3XAa1weLdqNkvXUSffebCUdacMfBv/HpDkhSjusZnG5H82+Sq4pLQPZTniw1
         CyaQA8uX3Qhlfhp+D757Vlrln8zvRzPbTlybMem3gW63EZi66C07MKUjqiHoqpwE9KP7
         uzu37hn9jVeWEKqiRK9ZmBV093A+i+5mb4psR5LRkpzarpGsra96Z274ApOMe3agtnxI
         s72UBIurS+FKBxqvZFUXq8YFhljz253Ayi+QWfyPmfzpWQ+RKC0NWuGOAtDKmfa+QbU3
         y3zdj7z8JUDkZ9A10nLgrjIHlYpM80hynvrh3UdHr6rFnGnkxfUhPUxtIv0yFUajSR/A
         pcCA==
X-Gm-Message-State: AAQBX9cI5Fw3QraHNQO/Pd7uVSxb9Zq33zFdnWa3IwBB8rqMD+Ma3ro+
        MdK+46Pjq67vRkWe0fp/916Ex4yMyQ==
X-Google-Smtp-Source: AKy350aJ6h65ENKDGuv6javi5hpdIYx3FtFdawgKK8IQG5QLN2+FWPP1Sks4yTp40K/P+Ldr/TLnNQ==
X-Received: by 2002:aca:1a09:0:b0:387:3239:61fa with SMTP id a9-20020aca1a09000000b00387323961famr4415278oia.30.1680800998716;
        Thu, 06 Apr 2023 10:09:58 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k9-20020acaba09000000b00387367989d7sm878253oif.23.2023.04.06.10.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 10:09:58 -0700 (PDT)
Received: (nullmailer pid 3363580 invoked by uid 1000);
        Thu, 06 Apr 2023 17:09:57 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-wireless@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        ath10k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>
In-Reply-To: <20230406-topic-ath10k_bindings-v3-1-00895afc7764@linaro.org>
References: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
 <20230406-topic-ath10k_bindings-v3-1-00895afc7764@linaro.org>
Message-Id: <168080086267.3336076.3393733023108971913.robh@kernel.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Convert ATH10K to YAML
Date:   Thu, 06 Apr 2023 12:09:57 -0500
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On Thu, 06 Apr 2023 14:55:44 +0200, Konrad Dybcio wrote:
> Convert the ATH10K bindings to YAML.
> 
> Dropped properties that are absent at the current state of mainline:
> - qcom,msi_addr
> - qcom,msi_base
> 
> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
> be reconsidered on the driver side, especially the latter one.
> 
> Somewhat based on the ath11k bindings.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          | 215 -------------
>  .../bindings/net/wireless/qcom,ath10k.yaml         | 357 +++++++++++++++++++++
>  2 files changed, 357 insertions(+), 215 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230406-topic-ath10k_bindings-v3-1-00895afc7764@linaro.org


wifi@0,0: reg: [[65536, 0, 0, 0, 0], [50397200, 0, 0, 0, 2097152]] is too long
	arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dtb

wifi@18800000: 'qcom,snoc-host-cap-skip-quirk' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dtb

