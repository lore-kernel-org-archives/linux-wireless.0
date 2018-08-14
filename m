Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46321 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbeHOChM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 22:37:12 -0400
Received: by mail-yw1-f68.google.com with SMTP id e23-v6so17571515ywe.13
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 16:47:39 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id z186-v6sm10163643ywa.101.2018.08.14.16.47.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Aug 2018 16:47:36 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id j68-v6so17599152ywg.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 16:47:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180814223519.13610-1-surenb@google.com>
References: <20180814223519.13610-1-surenb@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 14 Aug 2018 16:47:35 -0700
Message-ID: <CAGXu5jLAJnJpW4JKhfA=y7Nyt+_6svC5-sCAThubFgdCF1JZbA@mail.gmail.com> (sfid-20180815_014742_898920_E31DF5D5)
Subject: Re: [PATCH 1/1] NFC: Fix the number of pipes
To: Suren Baghdasaryan <surenb@google.com>
Cc: Security Officers <security@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 3:35 PM, Suren Baghdasaryan <surenb@google.com> wrote:
> According to ETSI TS 102 622 specification chapter 4.4 pipe identifier
> is 7 bits long which allows for 128 unique pipe IDs. Because
> NFC_HCI_MAX_PIPES is used as the number of pipes supported and not
> as the max pipe ID, its value should be 128 instead of 127.
>
> nfc_hci_recv_from_llc extracts pipe ID from packet header using
> NFC_HCI_FRAGMENT(0x7F) mask which allows for pipe ID value of 127.
> Same happens when NCI_HCP_MSG_GET_PIPE() is being used. With
> pipes array having only 127 elements and pipe ID of 127 the OOB memory
> access will result.
>
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  include/net/nfc/hci.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
> index 316694dafa5b..008f466d1da7 100644
> --- a/include/net/nfc/hci.h
> +++ b/include/net/nfc/hci.h
> @@ -87,7 +87,7 @@ struct nfc_hci_pipe {
>   * According to specification 102 622 chapter 4.4 Pipes,
>   * the pipe identifier is 7 bits long.
>   */
> -#define NFC_HCI_MAX_PIPES              127
> +#define NFC_HCI_MAX_PIPES              128
>  struct nfc_hci_init_data {
>         u8 gate_count;
>         struct nfc_hci_gate gates[NFC_HCI_MAX_CUSTOM_GATES];
> --
> 2.18.0.865.gffc8e1a3cd6-goog
>



-- 
Kees Cook
Pixel Security
