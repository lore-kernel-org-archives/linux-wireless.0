Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5D6C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB3B217D9
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 08:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTipYG6i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfDJIxK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 04:53:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42860 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbfDJIxK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 04:53:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id w25so1042674pfi.9;
        Wed, 10 Apr 2019 01:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MAwA8hdcGfucrSp9x2LdZHnMV91ksCJGxM5uXbbJCtY=;
        b=JTipYG6iK0X5X1nmc9EvGfJ0YCn8chNQPHnQm7tekpIo64uFjqjB9TTWSmYR3p2dx1
         zKw4VN9hmz6TSOBo4ouIrBarjF1yuREgL8i5e+ecToq+Br2zrGEL+si/n/6+HIdM8J1a
         b+W3gWbrdJcrjOPvvVP18247T9LTYWT1eIiNEAXgoRbyEXYv069DoOFuFW4AtFvmEqZE
         47AmQV4CifH0Hty+LHZ9/kdFuU4qwIhoT2LGJK89islYyIofFGmPjIE8Y8C3D2iF7HTC
         6gfb/eBBSPmayR00oCqW7xQ3X+4q2HwSlGPEeXocBxdlSBgaLPQBAlMOIoPIpLy99Xyu
         VSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MAwA8hdcGfucrSp9x2LdZHnMV91ksCJGxM5uXbbJCtY=;
        b=OwdUBIaCDat2YfS6FpBCItKOyycfvHUBBiv+R5san8BUvxnerMhgbj0lmUbE3KhBFm
         TJg/sjYa503pqkCnfedieSM9bBSJbpjqlNw/qGDUJTV5+jCfpVc0Kyega/pBQa+ZeczO
         e+g09Smi13fZf1KsYnrlO/mUXXP/ShdRI025vL0xLHGEmAOBbw156sG6xeAH1wMsI1mE
         ZGI3b8Qqz5rlbxnE2DMCxC7aFFk6TRhni04php9y6l7KpbuUWfk/8SCPANy4N9A5I6zo
         27n3rWWaGX1E1u8vwx1PpnocmVS1O8YtElu5obP2OAPcg6JTH2C8IB6dlC9CYoFK/mer
         5AiQ==
X-Gm-Message-State: APjAAAXNSCzQy3BgdfbSkhWf1BY01C/TU4p8NIYFTcUpT6zjm2aL3wrr
        zU8N41rPLgU3rnT2pjMqj9s=
X-Google-Smtp-Source: APXvYqxhkSaBHCeSJPrwvXou8ZFtLhANs4PeNDP819FhRRYIEPqUShqy+ScgDv8TvtNjZsL9uSUc/w==
X-Received: by 2002:a63:2a8f:: with SMTP id q137mr38826358pgq.31.1554886389327;
        Wed, 10 Apr 2019 01:53:09 -0700 (PDT)
Received: from localhost ([175.223.11.210])
        by smtp.gmail.com with ESMTPSA id l192sm22246219pge.42.2019.04.10.01.53.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Apr 2019 01:53:08 -0700 (PDT)
Date:   Wed, 10 Apr 2019 17:53:05 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated
 by lines '|'
Message-ID: <20190410085305.GA4937@jagdpanzerIV>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-5-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410031720.11067-5-alastair@au1.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On (04/10/19 13:17), Alastair D'Silva wrote:
> With the wider display format, it can become hard to identify how many
> bytes into the line you are looking at.
> 
> The patch adds new flags to hex_dump_to_buffer() and print_hex_dump() to
> print vertical lines to separate every N groups of bytes.
> 
> eg.
> buf:00000000: 454d414e 43415053|4e495f45 00584544  NAMESPAC|E_INDEX.
> buf:00000010: 00000000 00000002|00000000 00000000  ........|........

What if the output had |-s in it?  |||||||||

	-ss
