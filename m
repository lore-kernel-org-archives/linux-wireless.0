Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51284 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1FNQbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 12:31:42 -0400
Message-ID: <4DF78CEC.70409@gnu.org> (sfid-20110614_183152_337875_814B49D1)
Date: Tue, 14 Jun 2011 12:31:40 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, Intel Linux Wireless <ilw@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [ath9k-devel] [PATCH net-next 1/2] wireless: Remove casts of
 void *
References: <cover.1308024069.git.joe@perches.com> <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
In-Reply-To: <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2011 12:02 AM, Joe Perches wrote:

>   		/* Get the message ID */
> -		msg_id = (__be16 *) ((void *) htc_hdr +
> -				     sizeof(struct htc_frame_hdr));
> +		msg_id = (void *)htc_hdr + sizeof(struct htc_frame_hdr);

I would never do stuff like this without verifying by sparse that no 
warnings are introduced.

Sparse warnings should be avoided to keep sparse checks useful. 
Otherwise, important warnings would drown in the noise.

-- 
Regards,
Pavel Roskin
