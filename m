Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:36034 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdBIOfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 09:35:02 -0500
Received: by mail-qt0-f170.google.com with SMTP id k15so5231721qtg.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2017 06:34:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486558291-1615-3-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com> <1486558291-1615-3-git-send-email-sgruszka@redhat.com>
From: Jeroen Roovers <jer@airfi.aero>
Date: Thu, 9 Feb 2017 15:34:38 +0100
Message-ID: <CANCHnQpzBPX=Lcz2-YWHHwT-VxGE86_AoX=FG87Tg_Nq01Zimg@mail.gmail.com> (sfid-20170209_153511_823517_31540D43)
Subject: Re: [PATCH 2/3] rt2x00: call entry directly in rt2x00_dump_frame
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 13:51, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h      | 4 ++--

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index ea299c4..26869b3 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -1400,11 +1400,11 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
>   */
>  #ifdef CONFIG_RT2X00_LIB_DEBUGFS
>  void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
> -                           enum rt2x00_dump_type type, struct sk_buff *skb);
> +                           enum rt2x00_dump_type type, struct queue_entry *entry);
>  #else
>  static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
>                                           enum rt2x00_dump_type type,
> -                                         struct sk_buff *skb)
> +                                         struct queue_entry *entry)
>  {
>  }
>  #endif /* CONFIG_RT2X00_LIB_DEBUGFS */

In the comment above that, you forgot to update:

 * @skb: The skb containing the frame to be dumped.


Cheers,
     jer
