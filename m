Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab0KLSiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:38:13 -0500
Subject: Re: [PATCH] compat-wireless: support backporting bluetooth to RHEL
 6
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <20101112181348.GG2338@tuxdriver.com>
References: <20101112181348.GG2338@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 10:39:32 -0800
Message-ID: <1289587172.3736.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-12 at 13:13 -0500, John W. Linville wrote:
>   
> -+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
> ++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))

Hmmm. I kinda support this, but I'd rather see something like a header
file having

#if (LINUX_VERSION ...) || ...
#define OLD_BT_API 1
#endif

and then using ifdef OLD_BT_API? That way, other distros don't get into
a huge mess trying to add that too, and something like we had two days
ago where we had to make it work on some other custom kernel would be
much easier too since we can just amend the one check or define/undef
the OLD_BT_API symbol.

johannes

