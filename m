Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:37620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935453AbcA1A6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 19:58:32 -0500
Message-ID: <1453942708.10099.41.camel@perches.com> (sfid-20160128_015836_420565_0F3742F8)
Subject: Re: [PATCH] lib: fix callers of strtobool to use char array
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Date: Wed, 27 Jan 2016 16:58:28 -0800
In-Reply-To: <20160128004542.GA15247@www.outflux.net>
References: <20160128004542.GA15247@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 16:45 -0800, Kees Cook wrote:
> Some callers of strtobool were passing a pointer to unterminated strings.
> This fixes the issue and consolidates some logic in cifs.

This may be incomplete as it duplicates the behavior for
the old number of characters, but this is not a solution
for the entry of a bool that is "on" or "off".

> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
[]
> @@ -290,7 +305,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
>  			}
>  		}
>  		spin_unlock(&cifs_tcp_ses_lock);
> -	}
> +	} else
> +		return rc;

Likely better to reverse the test and unindent the
preceding block.

Otherwise, please make sure to use the general brace
form of when one branch needs braces, the other branch
should have them too.

