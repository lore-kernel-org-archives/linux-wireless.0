Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:3975 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYJFSf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:35:59 -0400
Received: by mu-out-0910.google.com with SMTP id g7so2414218muf.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 11:35:56 -0700 (PDT)
Message-ID: <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com> (sfid-20081006_203602_301755_EBCB998B)
Date: Mon, 6 Oct 2008 20:35:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223311803.15196.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 6:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> This makes the code surrounding the last few things using
> IWL_SET_BITS16 actually readable and removes the macros
> so nobody will ever consider using them again.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I don't want these macros eithers but I NACK any patches with cursing
in the commit logs.
Thanks
Tomas

> ---
> Tested on 5000 hw.
>
>  drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   82 ++++++++---------------
>  drivers/net/wireless/iwlwifi/iwl-4965.c    |   15 ++--
>  drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   55 +++++++--------
>  drivers/net/wireless/iwlwifi/iwl-5000.c    |   41 ++++++-----
>  drivers/net/wireless/iwlwifi/iwl-helpers.h |  102 -----------------------------
>  drivers/net/wireless/iwlwifi/iwl-tx.c      |    6 -
>  6 files changed, 90 insertions(+), 211 deletions(-)
>
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965-hw.h    2008-10-06 18:01:57.207234025 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965-hw.h 2008-10-06 18:27:22.318362726 +0200
> @@ -857,18 +857,24 @@ struct iwl_tfd_addr_desc {
>  * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
>  */
>  struct iwl_tfd_frame {
> -       __le32 val0;
> -       /* __le32 rsvd1:24; */
> -       /* __le32 num_tbs:5; */
> -#define IWL_num_tbs_POS 24
> -#define IWL_num_tbs_LEN 5
> -#define IWL_num_tbs_SYM val0
> -       /* __le32 rsvd2:1; */
> -       /* __le32 padding:2; */
> +       u8 reserved1[3];
> +       u8 num_tbs; /* 5 bits, rest reserved/padding */
>        struct iwl_tfd_addr_desc addrs[20];
>        __le32 reserved;
>  } __attribute__ ((packed));
>
> +static inline u8 iwl_get_num_tbs(struct iwl_tfd_frame *frame)
> +{
> +       return frame->num_tbs & 0x1f;
> +}
> +
> +static inline void iwl_set_num_tbs(struct iwl_tfd_frame *frame, u8 num_tbs)
> +{
> +       BUG_ON(num_tbs >= 20);
> +
> +       frame->num_tbs &= ~0x1f;
> +       frame->num_tbs |= num_tbs;
> +}
>
>  static inline dma_addr_t iwl_get_addr(struct iwl_tfd_frame *frame, u8 idx)
>  {
> @@ -914,25 +920,6 @@ static inline void iwl_set_len(struct iw
>
>
>  /**
> - * struct iwl4965_queue_byte_cnt_entry
> - *
> - * Byte Count Table Entry
> - *
> - * Bit fields:
> - * 15-12: reserved
> - * 11- 0: total to-be-transmitted byte count of frame (does not include command)
> - */
> -struct iwl4965_queue_byte_cnt_entry {
> -       __le16 val;
> -       /* __le16 byte_cnt:12; */
> -#define IWL_byte_cnt_POS 0
> -#define IWL_byte_cnt_LEN 12
> -#define IWL_byte_cnt_SYM val
> -       /* __le16 rsvd:4; */
> -} __attribute__ ((packed));
> -
> -
> -/**
>  * struct iwl4965_sched_queue_byte_cnt_tbl
>  *
>  * Byte Count table
> @@ -951,13 +938,23 @@ struct iwl4965_queue_byte_cnt_entry {
>  * 4965 assumes tables are separated by 1024 bytes.
>  */
>  struct iwl4965_sched_queue_byte_cnt_tbl {
> -       struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL49_QUEUE_SIZE +
> -                                                      IWL49_MAX_WIN_SIZE];
> +       /* highest 4 bits of each entry are reserved */
> +       __le16 _tfd_offset[IWL49_QUEUE_SIZE + IWL49_MAX_WIN_SIZE];
>        u8 dont_care[1024 -
>                     (IWL49_QUEUE_SIZE + IWL49_MAX_WIN_SIZE) *
>                     sizeof(__le16)];
>  } __attribute__ ((packed));
>
> +static inline void
> +iwl4965_queue_byte_cnt_set(struct iwl4965_sched_queue_byte_cnt_tbl *tbl,
> +                          u32 idx, u16 cnt)
> +{
> +       BUG_ON(idx >= IWL49_QUEUE_SIZE + IWL49_MAX_WIN_SIZE);
> +       BUG_ON(cnt > 0xFFF);
> +       tbl->_tfd_offset[idx] &= cpu_to_le16(~0xFFF);
> +       tbl->_tfd_offset[idx] |= cpu_to_le16(cnt);
> +}
> +
>
>  /**
>  * struct iwl4965_shared - handshake area for Tx and Rx
> @@ -985,30 +982,11 @@ struct iwl4965_sched_queue_byte_cnt_tbl
>  struct iwl4965_shared {
>        struct iwl4965_sched_queue_byte_cnt_tbl
>         queues_byte_cnt_tbls[IWL49_NUM_QUEUES];
> -       __le32 rb_closed;
> +       __le16 rb_closed_stts_rb_num_rsvd; /* high 4 bits reserved */
> +       __le16 rb_closed_stts_rx_frame_num_rsvd; /* high 4 bits reserved */
>
> -       /* __le32 rb_closed_stts_rb_num:12; */
> -#define IWL_rb_closed_stts_rb_num_POS 0
> -#define IWL_rb_closed_stts_rb_num_LEN 12
> -#define IWL_rb_closed_stts_rb_num_SYM rb_closed
> -       /* __le32 rsrv1:4; */
> -       /* __le32 rb_closed_stts_rx_frame_num:12; */
> -#define IWL_rb_closed_stts_rx_frame_num_POS 16
> -#define IWL_rb_closed_stts_rx_frame_num_LEN 12
> -#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
> -       /* __le32 rsrv2:4; */
> -
> -       __le32 frm_finished;
> -       /* __le32 frame_finished_stts_rb_num:12; */
> -#define IWL_frame_finished_stts_rb_num_POS 0
> -#define IWL_frame_finished_stts_rb_num_LEN 12
> -#define IWL_frame_finished_stts_rb_num_SYM frm_finished
> -       /* __le32 rsrv3:4; */
> -       /* __le32 frame_finished_stts_rx_frame_num:12; */
> -#define IWL_frame_finished_stts_rx_frame_num_POS 16
> -#define IWL_frame_finished_stts_rx_frame_num_LEN 12
> -#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
> -       /* __le32 rsrv4:4; */
> +       __le16 frm_finished_stts_rb_num_rsvd; /* high 4 bits reserved */
> +       __le16 frm_finished_stts_rx_frame_num_rsvd; /* high 4 bits rsvd */
>
>        __le32 padding1;  /* so that allocation will be aligned to 16B */
>        __le32 padding2;
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c 2008-10-06 18:01:30.487483581 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c      2008-10-06 18:05:49.150109045 +0200
> @@ -76,7 +76,7 @@ static void iwl_hw_txq_free_tfd(struct i
>                return;
>
>        /* Sanity check on number of chunks */
> -       counter = IWL_GET_BITS(*bd, num_tbs);
> +       counter = iwl_get_num_tbs(bd);
>        if (counter >= MAX_NUM_OF_TBS) {
>                IWL_ERROR("Too many chunks: %i\n", counter);
>                /* @todo issue fatal error, it is quite serious situation */
> @@ -97,7 +97,7 @@ static int iwl_hw_txq_attach_buf_to_tfd(
>                                 dma_addr_t addr, u16 len)
>  {
>        struct iwl_tfd_frame *tfd = ptr;
> -       u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
> +       u32 num_tbs = iwl_get_num_tbs(tfd);
>
>        /* Each TFD can point to a maximum 20 Tx buffers */
>        if (num_tbs >= MAX_NUM_OF_TBS) {
> @@ -109,7 +109,7 @@ static int iwl_hw_txq_attach_buf_to_tfd(
>        iwl_set_addr(tfd, num_tbs, addr);
>        iwl_set_len(tfd, num_tbs, len);
>
> -       IWL_SET_BITS(*tfd, num_tbs, num_tbs + 1);
> +       iwl_set_num_tbs(tfd, num_tbs + 1);
>
>        return 0;
>  }
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965.c       2008-10-06 18:15:26.712108096 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965.c    2008-10-06 18:28:03.086201127 +0200
> @@ -1653,7 +1653,7 @@ static int iwl4965_hw_channel_switch(str
>  static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
>  {
>        struct iwl4965_shared *s = priv->shared_virt;
> -       return le32_to_cpu(s->rb_closed) & 0xFFF;
> +       return le16_to_cpu(s->rb_closed_stts_rb_num_rsvd) & 0xFFF;
>  }
>
>  static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
> @@ -1666,7 +1666,8 @@ static int iwl4965_alloc_shared_mem(stru
>
>        memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
>
> -       priv->rb_closed_offset = offsetof(struct iwl4965_shared, rb_closed);
> +       priv->rb_closed_offset = offsetof(struct iwl4965_shared,
> +                                         rb_closed_stts_rb_num_rsvd);
>
>        return 0;
>  }
> @@ -1694,14 +1695,14 @@ static void iwl4965_txq_update_byte_cnt_
>        len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
>
>        /* Set up byte count within first 256 entries */
> -       IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                      tfd_offset[txq->q.write_ptr], byte_cnt, len);
> +       iwl4965_queue_byte_cnt_set(&shared_data->queues_byte_cnt_tbls[txq_id],
> +                                  txq->q.write_ptr, len);
>
>        /* If within first 64 entries, duplicate at end */
>        if (txq->q.write_ptr < IWL49_MAX_WIN_SIZE)
> -               IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                       tfd_offset[IWL49_QUEUE_SIZE + txq->q.write_ptr],
> -                       byte_cnt, len);
> +               iwl4965_queue_byte_cnt_set(
> +                       &shared_data->queues_byte_cnt_tbls[txq_id],
> +                       IWL49_QUEUE_SIZE + txq->q.write_ptr, len);
>  }
>
>  /**
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-5000-hw.h    2008-10-06 18:09:21.375233932 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-5000-hw.h 2008-10-06 18:32:50.180236365 +0200
> @@ -84,46 +84,43 @@
>  #define IWL50_NUM_AMPDU_QUEUES           10
>  #define IWL50_FIRST_AMPDU_QUEUE                  10
>
> -#define IWL_sta_id_POS 12
> -#define IWL_sta_id_LEN 4
> -#define IWL_sta_id_SYM val
> -
>  /* Fixed (non-configurable) rx data from phy */
>
>  /* Base physical address of iwl5000_shared is provided to SCD_DRAM_BASE_ADDR
>  * and &iwl5000_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG */
>  struct iwl5000_sched_queue_byte_cnt_tbl {
> -       struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL50_QUEUE_SIZE +
> -                                                      IWL50_MAX_WIN_SIZE];
> +       /* highest 4 bits of each entry are sta ID */
> +       __le16 _tfd_offset[IWL50_QUEUE_SIZE + IWL50_MAX_WIN_SIZE];
>  } __attribute__ ((packed));
>
> +static inline void
> +iwl5000_queue_byte_cnt_set(struct iwl5000_sched_queue_byte_cnt_tbl *tbl,
> +                          u32 idx, u16 cnt)
> +{
> +       BUG_ON(idx >= IWL50_QUEUE_SIZE + IWL50_MAX_WIN_SIZE);
> +       BUG_ON(cnt > 0xFFF);
> +       tbl->_tfd_offset[idx] &= cpu_to_le16(~0xFFF);
> +       tbl->_tfd_offset[idx] |= cpu_to_le16(cnt);
> +}
> +
> +static inline void
> +iwl5000_queue_sta_id_set(struct iwl5000_sched_queue_byte_cnt_tbl *tbl,
> +                        u32 idx, u16 sta_id)
> +{
> +       BUG_ON(idx >= IWL50_QUEUE_SIZE + IWL50_MAX_WIN_SIZE);
> +       BUG_ON(sta_id > 0xF);
> +       tbl->_tfd_offset[idx] &= cpu_to_le16(0xFFF);
> +       tbl->_tfd_offset[idx] |= cpu_to_le16(sta_id << 12);
> +}
> +
>  struct iwl5000_shared {
>        struct iwl5000_sched_queue_byte_cnt_tbl
>         queues_byte_cnt_tbls[IWL50_NUM_QUEUES];
> -       __le32 rb_closed;
> +       __le16 rb_closed_stts_rb_num_rsvd; /* high 4 bits reserved */
> +       __le16 rb_closed_stts_rx_frame_num_rsvd; /* high 4 bits reserved */
>
> -       /* __le32 rb_closed_stts_rb_num:12; */
> -#define IWL_rb_closed_stts_rb_num_POS 0
> -#define IWL_rb_closed_stts_rb_num_LEN 12
> -#define IWL_rb_closed_stts_rb_num_SYM rb_closed
> -       /* __le32 rsrv1:4; */
> -       /* __le32 rb_closed_stts_rx_frame_num:12; */
> -#define IWL_rb_closed_stts_rx_frame_num_POS 16
> -#define IWL_rb_closed_stts_rx_frame_num_LEN 12
> -#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
> -       /* __le32 rsrv2:4; */
> -
> -       __le32 frm_finished;
> -       /* __le32 frame_finished_stts_rb_num:12; */
> -#define IWL_frame_finished_stts_rb_num_POS 0
> -#define IWL_frame_finished_stts_rb_num_LEN 12
> -#define IWL_frame_finished_stts_rb_num_SYM frm_finished
> -       /* __le32 rsrv3:4; */
> -       /* __le32 frame_finished_stts_rx_frame_num:12; */
> -#define IWL_frame_finished_stts_rx_frame_num_POS 16
> -#define IWL_frame_finished_stts_rx_frame_num_LEN 12
> -#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
> -       /* __le32 rsrv4:4; */
> +       __le16 frm_finished_stts_rb_num_rsvd; /* high 4 bits reserved */
> +       __le16 frm_finished_stts_rx_frame_num_rsvd; /* high 4 bits rsvd */
>
>        __le32 padding1;  /* so that allocation will be aligned to 16B */
>        __le32 padding2;
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-5000.c       2008-10-06 18:09:08.752483265 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-5000.c    2008-10-06 18:32:08.379109332 +0200
> @@ -856,7 +856,8 @@ static int iwl5000_alloc_shared_mem(stru
>
>        memset(priv->shared_virt, 0, sizeof(struct iwl5000_shared));
>
> -       priv->rb_closed_offset = offsetof(struct iwl5000_shared, rb_closed);
> +       priv->rb_closed_offset = offsetof(struct iwl5000_shared,
> +                                         rb_closed_stts_rb_num_rsvd);
>
>        return 0;
>  }
> @@ -873,7 +874,7 @@ static void iwl5000_free_shared_mem(stru
>  static int iwl5000_shared_mem_rx_idx(struct iwl_priv *priv)
>  {
>        struct iwl5000_shared *s = priv->shared_virt;
> -       return le32_to_cpu(s->rb_closed) & 0xFFF;
> +       return le16_to_cpu(s->rb_closed_stts_rb_num_rsvd) & 0xFFF;
>  }
>
>  /**
> @@ -908,19 +909,18 @@ static void iwl5000_txq_update_byte_cnt_
>                }
>        }
>
> -       IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                      tfd_offset[txq->q.write_ptr], byte_cnt, len);
> -
> -       IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                      tfd_offset[txq->q.write_ptr], sta_id, sta);
> +       iwl5000_queue_byte_cnt_set(&shared_data->queues_byte_cnt_tbls[txq_id],
> +                                  txq->q.write_ptr, len);
> +       iwl5000_queue_sta_id_set(&shared_data->queues_byte_cnt_tbls[txq_id],
> +                                txq->q.write_ptr, sta);
>
>        if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
> -               IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                       tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
> -                       byte_cnt, len);
> -               IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
> -                       tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
> -                       sta_id, sta);
> +               iwl5000_queue_byte_cnt_set(
> +                       &shared_data->queues_byte_cnt_tbls[txq_id],
> +                       IWL50_QUEUE_SIZE + txq->q.write_ptr, len);
> +               iwl5000_queue_sta_id_set(
> +                       &shared_data->queues_byte_cnt_tbls[txq_id],
> +                       IWL50_QUEUE_SIZE + txq->q.write_ptr, sta);
>        }
>  }
>
> @@ -934,13 +934,18 @@ static void iwl5000_txq_inval_byte_cnt_t
>        if (txq_id != IWL_CMD_QUEUE_NUM)
>                sta = txq->cmd[txq->q.read_ptr]->cmd.tx.sta_id;
>
> -       shared_data->queues_byte_cnt_tbls[txq_id].tfd_offset[txq->q.read_ptr].
> -                                       val = cpu_to_le16(1 | (sta << 12));
> +       iwl5000_queue_byte_cnt_set(&shared_data->queues_byte_cnt_tbls[txq_id],
> +                                  txq->q.read_ptr, 1);
> +       iwl5000_queue_sta_id_set(&shared_data->queues_byte_cnt_tbls[txq_id],
> +                                txq->q.read_ptr, sta);
>
>        if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
> -               shared_data->queues_byte_cnt_tbls[txq_id].
> -                       tfd_offset[IWL50_QUEUE_SIZE + txq->q.read_ptr].
> -                               val = cpu_to_le16(1 | (sta << 12));
> +               iwl5000_queue_byte_cnt_set(
> +                       &shared_data->queues_byte_cnt_tbls[txq_id],
> +                       IWL50_QUEUE_SIZE + txq->q.read_ptr, 1);
> +               iwl5000_queue_sta_id_set(
> +                       &shared_data->queues_byte_cnt_tbls[txq_id],
> +                       IWL50_QUEUE_SIZE + txq->q.read_ptr, sta);
>        }
>  }
>
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-helpers.h    2008-10-06 18:01:02.250108736 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-helpers.h 2008-10-06 18:06:18.639110868 +0200
> @@ -32,108 +32,6 @@
>
>  #include <linux/ctype.h>
>
> -/*
> - * The structures defined by the hardware/uCode interface
> - * have bit-wise operations.  For each bit-field there is
> - * a data symbol in the structure, the start bit position
> - * and the length of the bit-field.
> - *
> - * iwl_get_bits and iwl_set_bits will return or set the
> - * appropriate bits on a 32-bit value.
> - *
> - * IWL_GET_BITS and IWL_SET_BITS use symbol expansion to
> - * expand out to the appropriate call to iwl_get_bits
> - * and iwl_set_bits without having to reference all of the
> - * numerical constants and defines provided in the hardware
> - * definition
> - */
> -
> -/**
> - * iwl_get_bits - Extract a hardware bit-field value
> - * @src: source hardware value (__le32)
> - * @pos: bit-position (0-based) of first bit of value
> - * @len: length of bit-field
> - *
> - * iwl_get_bits will return the bit-field in cpu endian ordering.
> - *
> - * NOTE:  If used from IWL_GET_BITS then pos and len are compile-constants and
> - *        will collapse to minimal code by the compiler.
> - */
> -static inline u32 iwl_get_bits(__le32 src, u8 pos, u8 len)
> -{
> -       u32 tmp = le32_to_cpu(src);
> -
> -       tmp >>= pos;
> -       tmp &= (1UL << len) - 1;
> -       return tmp;
> -}
> -
> -/**
> - * iwl_set_bits - Set a hardware bit-field value
> - * @dst: Address of __le32 hardware value
> - * @pos: bit-position (0-based) of first bit of value
> - * @len: length of bit-field
> - * @val: cpu endian value to encode into the bit-field
> - *
> - * iwl_set_bits will encode val into dst, masked to be len bits long at bit
> - * position pos.
> - *
> - * NOTE:  If used IWL_SET_BITS pos and len will be compile-constants and
> - *        will collapse to minimal code by the compiler.
> - */
> -static inline void iwl_set_bits(__le32 *dst, u8 pos, u8 len, int val)
> -{
> -       u32 tmp = le32_to_cpu(*dst);
> -
> -       tmp &= ~(((1UL << len) - 1) << pos);
> -       tmp |= (val & ((1UL << len) - 1)) << pos;
> -       *dst = cpu_to_le32(tmp);
> -}
> -
> -static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
> -{
> -       u16 tmp = le16_to_cpu(*dst);
> -
> -       tmp &= ~((1UL << (pos + len)) - (1UL << pos));
> -       tmp |= (val & ((1UL << len) - 1)) << pos;
> -       *dst = cpu_to_le16(tmp);
> -}
> -
> -/*
> - * The bit-field definitions in iwl-xxxx-hw.h are in the form of:
> - *
> - * struct example {
> - *         __le32 val1;
> - * #define IWL_name_POS 8
> - * #define IWL_name_LEN 4
> - * #define IWL_name_SYM val1
> - * };
> - *
> - * The IWL_SET_BITS and IWL_GET_BITS macros are provided to allow the driver
> - * to call:
> - *
> - * struct example bar;
> - * u32 val = IWL_GET_BITS(bar, name);
> - * val = val * 2;
> - * IWL_SET_BITS(bar, name, val);
> - *
> - * All cpu / host ordering, masking, and shifts are performed by the macros
> - * and iwl_{get,set}_bits.
> - *
> - */
> -#define IWL_SET_BITS(s, sym, v) \
> -       iwl_set_bits(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
> -                    IWL_ ## sym ## _LEN, (v))
> -
> -#define IWL_SET_BITS16(s, sym, v) \
> -       iwl_set_bits16(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
> -                      IWL_ ## sym ## _LEN, (v))
> -
> -#define IWL_GET_BITS(s, sym) \
> -       iwl_get_bits((s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
> -                     IWL_ ## sym ## _LEN)
> -
> -
>  #define KELVIN_TO_CELSIUS(x) ((x)-273)
>  #define CELSIUS_TO_KELVIN(x) ((x)+273)
>  #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
>
>
>
