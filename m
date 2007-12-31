Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46218 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXLaH2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 02:28:17 -0500
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Warning emited by 2.6.24-rc6-git5
References: <200712290942.37396.chris2553@googlemail.com>
	<200712291614.55732.IvDoorn@gmail.com>
	<200712301149.39388.chris2553@googlemail.com>
	<200712301311.42895.IvDoorn@gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 31 Dec 2007 09:27:35 +0200
In-Reply-To: <200712301311.42895.IvDoorn@gmail.com> (ext Ivo van Doorn's message of "Sun\, 30 Dec 2007 13\:11\:42 +0100")
Message-ID: <87abnrz5lk.fsf@nokia.com> (sfid-20071231_072819_979874_0C9AB3F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@gmail.com> writes:

> +		/*
> +		 * Move entire frame 2 bytes to the front.
> +		 */
> +		skb_push(skb, 2);
> +		memmove(skb->data, skb->data + 2, skb->len - 2);

No skb_trim()? Shoudn't there be skb_trim(skb, 2) after memmove()?

-- 
Kalle Valo
