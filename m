Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44872 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932362AbcI1N0n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 09:26:43 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix debug cal data file
Date: Wed, 28 Sep 2016 13:26:36 +0000
Message-ID: <87fuokw3xw.fsf@kamboji.qca.qualcomm.com> (sfid-20160928_152659_838310_1E40C50F)
References: <1474341984-19220-1-git-send-email-mar.kolya@gmail.com>
In-Reply-To: <1474341984-19220-1-git-send-email-mar.kolya@gmail.com> (Nikolay
        Martynov's message of "Mon, 19 Sep 2016 23:26:24 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay Martynov <mar.kolya@gmail.com> writes:

> It got broken by 0b8e3c4ca29fe2c0efd3d41a76e34a657b9f17a4
>
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>

Good catch, I'll queue this to 4.9.

There was one checkpatch warning I fixed:

drivers/net/wireless/ath/ath10k/debug.c:1477: Prefer vmalloc(sizeof(*data).=
..) over vmalloc(sizeof(struct ath10k_debug_cal_data)...)

The commit log is quite short so added more information about the bug.
The full patch is in the pending branch.

Author: Nikolay Martynov <mar.kolya@gmail.com>
Date:   Wed Sep 28 15:11:52 2016 +0300

    ath10k: fix debug cal data file
   =20
    Commit 0b8e3c4ca29f ("ath10k: move cal data len to hw_params") broke re=
trieving
    the calibration data from cal_data debugfs file. The length of file was=
 always
    zero. The reason is:
   =20
    static ssize_t ath10k_debug_cal_data_read(struct file *file,
                                          char __user *user_buf,
                                          size_t count, loff_t *ppos)
    {
        struct ath10k *ar =3D file->private_data;
        void *buf =3D file->private_data;
   =20
   =20
    This is obviously bogus, private_data cannot contain both struct ath10k=
 and the
    buffer. Fix it by introducing a new temporary structure for storing bot=
h the
    length of the buffer and the actual buffer, then struct ath10k is not n=
eeded
    anymore.
   =20
    Fixes: 0b8e3c4ca29f ("ath10k: move cal data len to hw_params")
    Cc: stable@vger.kernel.org # 4.7+
    Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
    [kvalo@qca.qualcomm.com: improve commit log, fix a checkpatch warning]
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

--=20
Kalle Valo=
