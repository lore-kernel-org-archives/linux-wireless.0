Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52738 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaJ3TaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 15:30:14 -0400
Date: Thu, 30 Oct 2014 15:19:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 0/3] debugfs: adding helper for single seq_file
Message-ID: <20141030191922.GA3768@tuxdriver.com> (sfid-20141030_203041_132470_11508DF7)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414498752-9746-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:19:09PM +0100, Arend van Spriel wrote:
> The first patch was already posted earlier:
> 
> Message-ID: <1413043315-22332-1-git-send-email-arend@broadcom.com>
> 
> This series include changes in driver code to investigate potential
> code savings. As example used the ath9k driver as it has a fair
> amount of debugfs files. In this series it changes 7 debugfs entries
> to use seq_file and the helper function. Below the output of the
> size utility:
> 
>    text	   data	    bss	    dec	    hex	filename
>  115968	   1225	     28	 117221	  1c9e5	original/ath9k.o
>  113224	   1225	     28	 114477	  1bf2d	seq_file/ath9k.o
>  111024	   1225	     28	 112277	  1b695	helper/ath9k.o
> 
> This series is for 3.19 kernel and applies to the driver-core-next
> branch of the driver-core repository. If needed the ath9k patches
> may be dropped for now and I will resubmit them to wireless-next
> once the debugfs patch has made it into linux-next.
> 
> Arend van Spriel (3):
>   debugfs: add helper function to create device related seq_file
>   ath: use seq_file api for ath9k debugfs files
>   ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file
>     entries

Greg,

If you are happy with the debugfs change then feel free to merge the
wireless patches along with it.

John

> 
>  drivers/net/wireless/ath/ath9k/ahb.c   |   1 +
>  drivers/net/wireless/ath/ath9k/debug.c | 429 +++++++++++----------------------
>  drivers/net/wireless/ath/ath9k/debug.h |   3 +-
>  drivers/net/wireless/ath/ath9k/pci.c   |   1 +
>  fs/debugfs/file.c                      |  54 +++++
>  include/linux/debugfs.h                |  16 +-
>  6 files changed, 207 insertions(+), 297 deletions(-)
> 
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
