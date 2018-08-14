Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35246 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbeHNDNG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 23:13:06 -0400
Received: by mail-yw1-f65.google.com with SMTP id s68-v6so14991494ywg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 17:28:29 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id u140-v6sm7691519ywf.4.2018.08.13.17.28.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Aug 2018 17:28:26 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id s68-v6so14991412ywg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 17:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180813223910.26276-1-surenb@google.com>
References: <20180813223910.26276-1-surenb@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Aug 2018 17:28:24 -0700
Message-ID: <CAGXu5jJGxr8fEJDEVciDo1VcF95brx31fAWV0ydYQj6Nq81MqQ@mail.gmail.com> (sfid-20180814_022843_022618_F401A2A5)
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
To: Suren Baghdasaryan <surenb@google.com>
Cc: Security Officers <security@kernel.org>, kdeus@google.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 3:39 PM, Suren Baghdasaryan <surenb@google.com> wrote:
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

Nice find!

Acked-by: Kees Cook <keescook@chromium.org>

> ---
>  net/nfc/hci/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
> index ac8030c4bcf8..19cb2e473ea6 100644
> --- a/net/nfc/hci/core.c
> +++ b/net/nfc/hci/core.c
> @@ -209,6 +209,11 @@ void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
>                 }
>                 create_info = (struct hci_create_pipe_resp *)skb->data;
>
> +               if (create_info->pipe >= NFC_HCI_MAX_PIPES) {
> +                       status = NFC_HCI_ANY_E_NOK;
> +                       goto exit;
> +               }
> +
>                 /* Save the new created pipe and bind with local gate,
>                  * the description for skb->data[3] is destination gate id
>                  * but since we received this cmd from host controller, we
> @@ -232,6 +237,11 @@ void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
>                 }
>                 delete_info = (struct hci_delete_pipe_noti *)skb->data;
>
> +               if (delete_info->pipe >= NFC_HCI_MAX_PIPES) {
> +                       status = NFC_HCI_ANY_E_NOK;
> +                       goto exit;
> +               }
> +
>                 hdev->pipes[delete_info->pipe].gate = NFC_HCI_INVALID_GATE;
>                 hdev->pipes[delete_info->pipe].dest_host = NFC_HCI_INVALID_HOST;
>                 break;
> --
> 2.18.0.597.ga71716f1ad-goog
>



-- 
Kees Cook
Pixel Security
