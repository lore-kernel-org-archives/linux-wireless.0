Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B42CD6E53
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Oct 2023 09:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjJKJUd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Oct 2023 05:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjJKJUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2023 05:20:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC41691;
        Wed, 11 Oct 2023 02:20:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AB2C433C8;
        Wed, 11 Oct 2023 09:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697016031;
        bh=ju74xlAz+WDMwoyepe65xhltEQNC+JPoiTlVmjOaOko=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ExCST8SGknwh7LJsiMX5ttjhAskvHlMNFC5dQwQqOlA0z7+je2lOeZw3T7N9czsb5
         uknL6sF3w6JVNKuQDaE7RvxzalH3Ck6jyXNiGwk7TDxNAQGbvVdlXpsOOl3/9y9Mv4
         9zmdkl4VxktJNfnjO9TVd8RgTYcPJ6XkOOSgHcOubBW/J8Iv5ZmnN52SjftuwBBeMd
         WvZNZjNMRWh5BhZ5JE98EIiDmej7i8r4Bw044xiJ/fs+XHLntXwi9lMqKn11c2QXj5
         g2Pl2HHYYy30dVjWjQc27QczOKXs2WU8gTKpO23YefjYDoCAdl6RodgSxj2Q0DxLtE
         3YI5N5Ap01zTA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [next] wifi: hostap: Add __counted_by for struct
 prism2_download_data and use struct_size()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZSRXXvWMMkm7qqRW@work>
References: <ZSRXXvWMMkm7qqRW@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169701602833.2760941.2948588134703156601.kvalo@kernel.org>
Date:   Wed, 11 Oct 2023 09:20:30 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time via CONFIG_UBSAN_BOUNDS (for
> array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> While there, use struct_size() helper, instead of the open-coded
> version, to calculate the size for the allocation of the whole
> flexible structure, including of course, the flexible-array member.
> 
> This code was found with the help of Coccinelle, and audited and
> fixed manually.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

5cf47dc14158 wifi: hostap: Add __counted_by for struct prism2_download_data and use struct_size()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZSRXXvWMMkm7qqRW@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

