Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46619 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1KRThg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:37:36 -0500
Message-ID: <4EC6B3FA.90502@hauke-m.de> (sfid-20111118_203739_629502_7D4CA1B1)
Date: Fri, 18 Nov 2011 20:37:30 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] compat: implement dummy security_sk_clone
References: <1321490374-24529-1-git-send-email-linville@tuxdriver.com> <1321490374-24529-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1321490374-24529-2-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 01:39 AM, John W. Linville wrote:
> This has been defined in include/linux/security.h for some time, but was
> only given an EXPORT_SYMBOL for 3.2.  Add a compat_* definition to avoid
> breaking the module load with an undefined symbol.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  include/linux/compat-3.2.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
> index ceaaecc..08f102f 100644
> --- a/include/linux/compat-3.2.h
> +++ b/include/linux/compat-3.2.h
> @@ -72,6 +72,17 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
>  	return buf;
>  }
>  
> +/*
> + * This has been defined in include/linux/security.h for some time, but was
> + * only given an EXPORT_SYMBOL for 3.2.  Add a compat_* definition to avoid
> + * breaking the compile.
> + */
> +#define security_sk_clone(a, b) compat_security_sk_clone(a, b)
> +
> +static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
> +{
> +}
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
>  
>  #endif /* LINUX_3_2_COMPAT_H */

Hi,

security_sk_clone gets also exported in Linux-3.1 so this should move to
include/linux/compat-3.1.h. 3.1-rcX did not contain this fix, but I hope
nobody is using this any more.

Hauke

$ git tag --contains 6230c9b4f8957c8938ee4cf2d03166d3c2dc89de
v3.1
v3.1.1
v3.2-rc1
v3.2-rc2
