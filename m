Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AD4C47080
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 19:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E9761260
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 19:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhEaTfS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 May 2021 15:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhEaTfR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 May 2021 15:35:17 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A27C061574
        for <linux-wireless@vger.kernel.org>; Mon, 31 May 2021 12:33:37 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnnfK-000DeU-Hq; Mon, 31 May 2021 21:33:34 +0200
Message-ID: <852730091c657314056f56ebebae57351ce7d354.camel@sipsolutions.net>
Subject: Re: [PATCH v2] iw: set retain atrribute on sections
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Manoj Gupta <manojgupta@google.com>
Cc:     llozano@google.com, linux-wireless@vger.kernel.org,
        Fangrui Song <maskray@google.com>
Date:   Mon, 31 May 2021 21:33:33 +0200
In-Reply-To: <20210426163021.3594482-1-manojgupta@google.com> (sfid-20210426_183030_475195_F16BBCA2)
References: <20210422182545.726897-1-manojgupta@google.com>
         <20210426163021.3594482-1-manojgupta@google.com>
         (sfid-20210426_183030_475195_F16BBCA2)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2021-04-26 at 09:30 -0700, Manoj Gupta wrote:
> LLD 13 and GNU ld 2.37 support -z start-stop-gc which allows garbage
> collection of C identifier name sections despite the __start_/__stop_
> references.  Simply set the retain attribute so that GCC 11 (if
> configure-time binutils is 2.36 or newer)/Clang 13 will set the
> SHF_GNU_RETAIN section attribute to prevent garbage collection.
> 
> Without the patch, there are linker errors like the following with -z
> start-stop-gc:
> ld.lld: error: undefined symbol: __stop___cmd
> > > > referenced by iw.c:418
> > > >               iw.o:(__handle_cmd)
> 
> Suggested-by: Fangrui Song <maskray@google.com>
> 
> Cc: stable@vger.kernel.org

This is *clearly* inappropriate.

> +++ b/iw.h
> @@ -118,8 +118,9 @@ struct chandef {
>  		.parent = _section,					\
>  		.selector = (_sel),					\
>  	};								\
> +	_Pragma("GCC diagnostic ignored \"-Wattributes\"") 		\
>  	static struct cmd *__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden ## _p \
> -	__attribute__((used,section("__cmd"))) =			\
> +	__attribute__((used,retain,section("__cmd"))) =			\
>  	&__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden
>  #define __ACMD(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel, _alias)\
>  	__COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel);\
> @@ -141,16 +142,18 @@ struct chandef {
>  		.handler = (_handler),					\
>  		.help = (_help),					\
>  	 };								\
> +	_Pragma("GCC diagnostic ignored \"-Wattributes\"") 		\
>  	static struct cmd *__section ## _ ## _name ## _p		\
> -	__attribute__((used,section("__cmd"))) = &__section ## _ ## _name
> +	__attribute__((used,retain,section("__cmd"))) = &__section ## _ ## _name

All of these cases are in macros, it feels it would be more appropriate
to do _Pragma("GCC diagnostic push") and ...pop... around it?

johannes

