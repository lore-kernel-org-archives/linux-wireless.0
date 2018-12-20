Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2122C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89BEF217D8
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 13:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="di/JbkBm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="di/JbkBm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbeLTNXg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:23:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732234AbeLTNXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 08:23:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B596660734; Thu, 20 Dec 2018 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545312215;
        bh=ycxepOkZp84jWYPywPQnf4uuN2onekVaUVMhSxwxil4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=di/JbkBmH6Oq1jk38gK1NYQjXbNOTSqTXhqBv9X4ulKopWMKe98eAV6TEOqEtEQcw
         oKu3cG4wSEqPEHgRlRWwibmff3UO1Dd1loPuPXHtuKrSXRH4KeEXwaF8UcUmS0NIVN
         TxWsDcGIuvYKdAxQ6JvSR9DBxTp0JcH3JLrUW/tI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6A776034E;
        Thu, 20 Dec 2018 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545312215;
        bh=ycxepOkZp84jWYPywPQnf4uuN2onekVaUVMhSxwxil4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=di/JbkBmH6Oq1jk38gK1NYQjXbNOTSqTXhqBv9X4ulKopWMKe98eAV6TEOqEtEQcw
         oKu3cG4wSEqPEHgRlRWwibmff3UO1Dd1loPuPXHtuKrSXRH4KeEXwaF8UcUmS0NIVN
         TxWsDcGIuvYKdAxQ6JvSR9DBxTp0JcH3JLrUW/tI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6A776034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v4 2/3] dt-bindings: net: ath10k: add new dt entry to identify external FEM
References: <1544544804-4039-1-git-send-email-bperumal@codeaurora.org>
        <1544544804-4039-3-git-send-email-bperumal@codeaurora.org>
        <20181217203718.GA29320@bogus>
Date:   Thu, 20 Dec 2018 15:23:31 +0200
In-Reply-To: <20181217203718.GA29320@bogus> (Rob Herring's message of "Mon, 17
        Dec 2018 14:37:18 -0600")
Message-ID: <87lg4ktjqk.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> On Tue, Dec 11, 2018 at 09:43:23PM +0530, Bhagavathi Perumal S wrote:
>> This adds new dt entry ext-fem-name, it is used by ath10k driver
>> to select correct timing parameters and configure it in target wifi hardware.
>> The Front End Module(FEM) normally includes tx power amplifier(PA) and
>> rx low noise amplifier(LNA). The default timing parameters like tx end to
>> PA off timing values were fine tuned for internal FEM used in reference
>> design. And these timing values can not be same if ODM modifies hardware
>> design with different external FEM. This DT entry helps to choose correct
>> timing values in driver if different external FEM hardware used.
>> 
>> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> Please add acks/reviewed-bys when posting new versions.

I added your reviewed-by from v3 in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=2f4f5a81c87b9be68aa087c238e2f2b9debbfa1b

-- 
Kalle Valo
