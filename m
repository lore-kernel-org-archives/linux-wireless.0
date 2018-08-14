Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbeHNMIA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 08:08:00 -0400
Date: Tue, 14 Aug 2018 11:21:35 +0200
From: Greg KH <greg@kroah.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: security@kernel.org, kdeus@google.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
Message-ID: <20180814092135.GA10316@kroah.com> (sfid-20180814_112215_720124_655C4449)
References: <20180813223910.26276-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180813223910.26276-1-surenb@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 03:39:08PM -0700, Suren Baghdasaryan wrote:
> When handling SHDLC I-Frame commands "pipe" field used for indexing
> into an array should be checked before usage. If left unchecked it
> might access memory outside of the array of size NFC_HCI_MAX_PIPES(127).
> 
> Malformed NFC HCI frames could be injected by a malicious NFC device
> communicating with the device being attacked (remote attack vector),
> or even by an attacker with physical access to the I2C bus such that
> they could influence the data transfers on that bus (local attack vector).
> skb->data is controlled by the attacker and has only been sanitized in
> the most trivial ways (CRC check), therefore we can consider the
> create_info struct and all of its members to tainted. 'create_info->pipe'
> with max value of 255 (uint8) is used to take an offset of the
> hdev->pipes array of 127 elements which can lead to OOB write.
> 
> Suggested-by: Kevin Deus <kdeus@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
