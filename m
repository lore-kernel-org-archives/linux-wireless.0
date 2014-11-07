Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaKGTFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:05:22 -0500
Date: Fri, 7 Nov 2014 11:05:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 2/3] ath: use seq_file api for ath9k debugfs files
Message-ID: <20141107190522.GA4694@kroah.com> (sfid-20141107_200525_911436_4D76E387)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
 <1414498752-9746-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414498752-9746-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:19:11PM +0100, Arend van Spriel wrote:
> The debugfs files that are defined in debug.c which are read-only
> and using a simple_open as .open file operation have been modified
> to use the single_open seq_file API. This simplifies the read
> functions defining the file contents.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Acked-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/debug.c | 425 +++++++++++++--------------------
>  drivers/net/wireless/ath/ath9k/debug.h |   3 +-
>  2 files changed, 173 insertions(+), 255 deletions(-)

I can't take patch 1/3 right now, but even if I could, this one doesn't
apply to 3.18-rc3 :(
