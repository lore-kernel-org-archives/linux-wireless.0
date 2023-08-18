Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C7DEE4992
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Aug 2023 21:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbjHRVZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240604AbjHRVYj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2023 17:24:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058262102;
        Fri, 18 Aug 2023 14:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AFD9666E9;
        Fri, 18 Aug 2023 21:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E71C433C7;
        Fri, 18 Aug 2023 21:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1692393876;
        bh=Wdz4oVuBLe9dL/FbEM8zLUrqIvKI32lgagofb0qvY6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCq6FBHKwur8aDhPsmBJ8x7a/pO6VKC1iTCOZWMlrV+nEghj+H0DqAjTnOlZUR00P
         OdozVSYiigsj0UhUy+ly+qwBkX+RJEOGfUzAj4Hwm6GEpTCj7+gItKltc+AVOsfrqs
         5g3zd+1+RH9uR0hpRVYfZeJOm9UwkwF1061rIaxY=
Date:   Fri, 18 Aug 2023 23:24:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Evan Quan <evan.quan@amd.com>
Cc:     rafael@kernel.org, lenb@kernel.org, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alexander.deucher@amd.com, andrew@lunn.ch,
        rdunlap@infradead.org, quic_jjohnson@quicinc.com, horms@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [V9 1/9] drivers core: Add support for Wifi band RF mitigations
Message-ID: <2023081806-rounding-distract-b695@gregkh>
References: <20230818032619.3341234-1-evan.quan@amd.com>
 <20230818032619.3341234-2-evan.quan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818032619.3341234-2-evan.quan@amd.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Aug 18, 2023 at 11:26:11AM +0800, Evan Quan wrote:
>  drivers/base/Makefile                         |   1 +
>  drivers/base/wbrf.c                           | 280 ++++++++++++++++++

Why is a wifi-specific thing going into drivers/base/?

confused,

greg k-h
