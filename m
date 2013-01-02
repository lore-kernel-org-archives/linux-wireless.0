Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34587 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3ABOiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:38:52 -0500
Received: by mail-ie0-f172.google.com with SMTP id c13so16960504ieb.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 06:38:51 -0800 (PST)
Date: Wed, 2 Jan 2013 09:37:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/17] cw1200: v2: WSM (ie host-firmware) host interface
Message-ID: <20130102143708.GA13185@localhost> (sfid-20130102_153900_522237_E6625FDD)
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
 <1356218312-13616-12-git-send-email-pizza@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356218312-13616-12-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 22, 2012 at 06:18:26PM -0500, Solomon Peachy wrote:
> +	size_t pos = buf->data - buf->begin;
> +	size_t size = pos + extra_size;
> +
> +
> +	if (size & (FWLOAD_BLOCK_SIZE - 1)) {
> +		size &= FWLOAD_BLOCK_SIZE;
> +		size += FWLOAD_BLOCK_SIZE;
> +	}

I think this should be

    size = round_up(size, FWLOAD_BLOCK_SIZE);

Otherwise it fails if size > 2 * FWLOAD_BLOCK_SIZE (it may never be,
but it still looks wrong).

-- 
Bob Copeland %% www.bobcopeland.com
