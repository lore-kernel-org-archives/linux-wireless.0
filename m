Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752722AbeD3TJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 15:09:10 -0400
Date: Mon, 30 Apr 2018 12:09:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sriram R <srirrama@codeaurora.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 2/2 - linux-stable-4.4] ath10k: rebuild crypto header in
 rx data frames
Message-ID: <20180430190901.GB8415@kroah.com> (sfid-20180430_210914_480632_F0EFC834)
References: <1525069587-19281-1-git-send-email-srirrama@codeaurora.org>
 <1525069587-19281-3-git-send-email-srirrama@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525069587-19281-3-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 11:56:27AM +0530, Sriram R wrote:
> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
> on host (mac80211) rather than firmware. Rebuild cipher header
> in every received data frames (that are notified through those
> HTT interfaces) from the rx_hdr_status tlv available in the
> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
> flag for the packets which requires mac80211 PN/TSC check support
> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
> and QCA99X0 currently need the rebuilding of cipher header to
> perform PN/TSC check for replay attack.
> 
> [Upstream Commit : 7eccb738fce57cbe53ed903ccf43f9ab257b15b3]
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 98 ++++++++++++++++++++++++++------
>  1 file changed, 82 insertions(+), 16 deletions(-)

This patch breaks the build.  Always test build your patches!

thanks,

greg k-h
