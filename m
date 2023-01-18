Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13140C32793
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Jan 2023 22:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjARWYv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARWYu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2023 17:24:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763CC63081
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2023 14:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674080640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33VsmywiSt+1st7fYNpGyVnbGYmu+R+zUG3V8a3kz1c=;
        b=Bq8T0f17vYl7nruS9KxO4mbAycH4C8baK/BuZ7NWOgnyOPvcjuxBbEsYDc7/qRrLh/XPU1
        yYXy2s0mW5ttl41DAmSnaJwD76k5TPll9875UTcgdBaqRMjh/lrh9P+UsTjovzPPUad/5b
        JSv8OpE+odgwqXqxWuBdHHb+wuBXEh0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-O1uVURL7MGKMhmobAY-30w-1; Wed, 18 Jan 2023 17:23:58 -0500
X-MC-Unique: O1uVURL7MGKMhmobAY-30w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1272A2A5956F;
        Wed, 18 Jan 2023 22:23:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3759A2026D4B;
        Wed, 18 Jan 2023 22:23:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <e7280be84acda02634bc7cb52c97656182b9c700.1673197326.git.lukas@wunner.de>
References: <e7280be84acda02634bc7cb52c97656182b9c700.1673197326.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     dhowells@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: Deduplicate certificate loading
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2700983.1674080634.1@warthog.procyon.org.uk>
Date:   Wed, 18 Jan 2023 22:23:54 +0000
Message-ID: <2700984.1674080634@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> load_keys_from_buffer() in net/wireless/reg.c duplicates
> x509_load_certificate_list() in crypto/asymmetric_keys/x509_loader.c
> for no apparent reason.
> 
> Deduplicate it.  No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: David Howells <dhowells@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>

