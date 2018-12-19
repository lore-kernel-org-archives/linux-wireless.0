Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFF9C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF27A2080D
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kMzYPW0h";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PrlS27Ie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbeLSMk6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 07:40:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbeLSMk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 07:40:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 36A6961BC2; Wed, 19 Dec 2018 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545223257;
        bh=z/beEom7psnfw9yQmlrnseXMYmjWKzeDm/sc9HG3Lb4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kMzYPW0haS2SVu6IXudayL5wFkuCy39x+bFvzYHxfCtzE/jRUl+WC/Amr57Mif6fl
         LDAyq+kZy3QHBjnOyKkHTKo1VittbM7VzMUwsgsMB8MQfiawNhrvsxRbw+8DIH3ocq
         aUtMc0EcFECqqeTUiIEiJ3xCNC26BtZK/ZTrSdz8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C640861B6A;
        Wed, 19 Dec 2018 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545223256;
        bh=z/beEom7psnfw9yQmlrnseXMYmjWKzeDm/sc9HG3Lb4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PrlS27IeGfXkbqaYuLl6qQmNr5HSVxpq/2/HLUgbGY88wvdk7qiXxrkNWzA0pmjHn
         QvxpKaCco05NSqzXhdrLrdBrl/10Mj/Ruw8Ks2OjCqqrpjcUkUpn01ufGePvH9CbeO
         Rj/fNOy8ASDCQg6z7ZVmgQh7rdYgQR1iNHvqoSQY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C640861B6A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sharon\, Sara" <sara.sharon@intel.com>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the wireless-drivers-next tree
References: <20181130120555.1d35eb6b@canb.auug.org.au>
        <20181219134738.4efed34f@canb.auug.org.au>
        <871s6evtra.fsf@kamboji.qca.qualcomm.com>
        <0BA3FCBA62E2DC44AF3030971E174FB3013375F96C@HASMSX112.ger.corp.intel.com>
Date:   Wed, 19 Dec 2018 14:40:51 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3013375F96C@HASMSX112.ger.corp.intel.com>
        (Emmanuel Grumbach's message of "Wed, 19 Dec 2018 08:31:54 +0000")
Message-ID: <87sgytvgdo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

>> 
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>> 
>> > On Fri, 30 Nov 2018 12:05:55 +1100 Stephen Rothwell
>> <sfr@canb.auug.org.au> wrote:
>> >>
>> >> After merging the wireless-drivers-next tree, today's linux-next
>> >> build
>> >> (x86_64 allmodconfig) produced these warnings:
>> >>
>> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function
>> 'iwl_parse_tlv_firmware':
>> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this
>> statement may fall through [-Wimplicit-fallthrough=]
>> >>     if (iwlwifi_mod_params.enable_ini)
>> >>        ^
>> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
>> >>    default:
>> >>    ^~~~~~~
>> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function
>> 'iwl_parse_fw_dbg_tlv':
>> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this
>> statement may fall through [-Wimplicit-fallthrough=]
>> >>     iwl_fw_dbg_copy_tlv(trans, tlv, true);
>> >>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
>> >>    default:
>> >>    ^~~~~~~
>> >>
>> >> Introduced by commit
>> >>
>> >>   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
>> >>
>> >> These are noted because I use -Wimplict-fallthrough
>> >>
>> >> The warnings can be suppressed by adding a comment like
>> >> 	/* fall through */
>> >> at the appropriate place to indicate that the fallthough is intended.
>> >
>> > I am still seeing these warnings (but in the net-next tree now) and I
>> > do not see a fix patch in the wireless-drivers-next tree.
>> 
>> Luca did submit a patch[1] for cfg80211 to fix those but I don't see any
>> patches for iwlwifi (even in the one pending pull request he sent), not sure
>> what happened. I know that Luca is already on holidays but adding
>> Emmanuel, maybe he can help here?
>> 
>
> Just sent a patch.

I see it thanks:

https://patchwork.kernel.org/patch/10736967/

I'll try to get it to tomorrow's linux-next build.

-- 
Kalle Valo
