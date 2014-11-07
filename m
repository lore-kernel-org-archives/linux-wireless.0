Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaKGTE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:04:56 -0500
Date: Fri, 7 Nov 2014 11:04:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/3] debugfs: add helper function to create device
 related seq_file
Message-ID: <20141107190455.GA4653@kroah.com> (sfid-20141107_200459_840020_489EEA7A)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
 <1414498752-9746-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414498752-9746-2-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:19:10PM +0100, Arend van Spriel wrote:
> This patch adds a helper function that simplifies adding a
> so-called single_open sequence file for device drivers. The
> calling device driver needs to provide a read function and
> a device pointer. The field struct seq_file::private will
> reference the device pointer upon call to the read function
> so the driver can obtain his data from it and do its task
> of providing the file content using seq_printf() calls and
> alike. Using this helper function also gets rid of the need
> to specify file operations per debugfs file.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  fs/debugfs/file.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/debugfs.h | 16 ++++++++++++++-
>  2 files changed, 69 insertions(+), 1 deletion(-)

Please run your patches through checkpatch before sending them so you
don't get grumpy emails from maintainers complaining about whitespace
errors :(
