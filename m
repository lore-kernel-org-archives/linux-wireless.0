Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966C4C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 10:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A81B2176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 10:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=albtraum.org header.i=@albtraum.org header.b="jcLvmeUa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbeLTKus (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 05:50:48 -0500
Received: from mail.albtraum.org ([94.130.183.3]:57646 "EHLO mail.albtraum.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbeLTKus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 05:50:48 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2018 05:50:44 EST
Received: from [128.178.122.103] (icdhcp-2-103.epfl.ch [128.178.122.103])
        by mail.albtraum.org (Postfix) with ESMTPSA id D6B781F437;
        Thu, 20 Dec 2018 11:43:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=albtraum.org; s=mail;
        t=1545302597; bh=Qr775KMw9la3CJZm3XyPK5nchF+0C1wTq0kay6U0lrc=;
        h=To:From:Subject:Cc:Date:From;
        b=jcLvmeUaIdIBo3AQo+ZLtp8BYDbXc5jQf4wVZ893dBBKgSri9Be076J57s6RCoqpA
         oEkg93WZxbVJthmoOyEnwpJK2Wp0OC/wqpUiF2/cQC6KHcESx7AzniIvmxGYVnoy8I
         7whACKln7FJ1DraizqlmKRXui+K+igredOZ847+XyIW9SDGcaqxAZdLj6Xq0OohUDV
         /461y0xRWtasnggnPBxJJ3+e7Np3F3+2DQAW40ET9ZKz6JWyl01xP1BeM9AimQwfAC
         LrsSK6tr8fHPpWMPjBEE3zDT1NLF/uTrszo+aeEiK4L5O1gPmApw/BctPZGLZQCgD/
         ZljQ/6kBZNfkg==
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
From:   Mathias Payer <mathias.payer@nebelwelt.net>
Subject: NULL deref in drivers/net/wireless/ath/ath{6kl|10k}/usb.c
Openpgp: preference=signencrypt
Autocrypt: addr=mathias.payer@nebelwelt.net; keydata=
 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
 6cVR5xSPwYD5e5fg6EsTcA==
Cc:     Hui Peng <peng124@purdue.edu>
Message-ID: <137aecba-a410-7795-61c9-0e431d75eaaa@nebelwelt.net>
Date:   Thu, 20 Dec 2018 11:43:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="arZUooOvS0hpXnBrEabj3jHEhTQJstzuF"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--arZUooOvS0hpXnBrEabj3jHEhTQJstzuF
Content-Type: multipart/mixed; boundary="aRpgVMyzsTfPcwLLl5W62uYxu2iof3ntP";
 protected-headers="v1"
From: Mathias Payer <mathias.payer@nebelwelt.net>
To: Kalle Valo <kvalo@codeaurora.org>, "David S. Miller"
 <davem@davemloft.net>, linux-wireless@vger.kernel.org
Cc: Hui Peng <peng124@purdue.edu>
Message-ID: <137aecba-a410-7795-61c9-0e431d75eaaa@nebelwelt.net>
Subject: NULL deref in drivers/net/wireless/ath/ath{6kl|10k}/usb.c

--aRpgVMyzsTfPcwLLl5W62uYxu2iof3ntP
Content-Type: multipart/mixed;
 boundary="------------A8C40E49416248C33B9CE440"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A8C40E49416248C33B9CE440
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi there,

We have developed a USB testing framework and found two NULL derefes in
the ath driver when an attacker-controlled USB device sends a malformed
USB packet. The bug is in drivers/net/wireless/ath/ath{6kl|10k}/usb.c We
show the bug for ath6kl/usb.c but the code seems to be copied over to
ath10k/usb.c and it is equally vulnerable.

```
ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pipe *pipe)
{
    struct ath6kl_urb_context *urb_context =3D NULL;
    unsigned long flags;

    // buggy statement
    spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);

    if (!list_empty(&pipe->urb_list_head)) {
        urb_context =3D
            list_first_entry(&pipe->urb_list_head,
                     struct ath6kl_urb_context, link);
        list_del(&urb_context->link);
        pipe->urb_cnt--;
    }
    spin_unlock_irqrestore(&pipe->ar_usb->cs_lock, flags);

    return urb_context;
}
```

The `field pipe->ar_usb` may be NULL if the corresponding pipes have not
been setup, resulting in a NULL pointer deref, when the spin_lock tries
to access the `cs_lock` field.

During setup, the initialization code allocates the pipes according to
whatever is requested from the USB channel, potentially missing the
initialization of some pipes.


# Code flow

1. `ath6kl_usb_probe` calls ` ath6kl_usb_create` to create an
`ath6kl_usb` object

2. Inside `ath6kl_usb_create`
(https://elixir.bootlin.com/linux/v4.14.81/source/drivers/net/wireless/at=
h/ath6kl/usb.c#L613)
    a. it allocates memory for the ath6kl_usb object using `kzalloc`
    b. the array of `ath6kl_usb_pipe` (`pipes` field) is setup by
       calling `ath6kl_usb_setup_pipe_resources`, where it may goes
       wrong

3. The `ath6kl_usb_setup_pipe_resources`
(https://elixir.bootlin.com/linux/v4.14.81/source/drivers/net/wireless/at=
h/ath6kl/usb.c#L295)
function iterates through all endpoints reported by the device and
initializes each pipe according to the endpoint information

It calculates the pipnum (the index to the pipes array) according to the
endpoint address by calling `ath6kl_usb_get_logical_pipe_num`, and then
sets up the pipe object. The selected pipe object's `ar_usb` field will
be set to the containing `ath6kl_usb` object.

If a pipe object is not selected  by the endpoint information, their
`ar_usb` field will be zero, as the underlying `ath6kl_usb` object is
allocated by `kzalloc`.

The driver assumes that all endpoint addresses are complete (covering
range 0 to MAX_PIPE_NUM), assuming all pipe objects are setup correctly.
A malicious USB device can force some pipes to not be setup.


# Proposed fix

As a simple fix, we propose to check for NULL in
ath6kl_usb_alloc_urb_from_pipe, making sure the underlying object was
correctly initialized. This *should* work for the two drivers and will
be a quick fix.

The cleanest solution would check at the end of
`ath6kl_usb_setup_pipe_resources` that all required pipes are set up
correctly. The question is what is the minimum set of pipes that the
hardware exports? As I don't have access to the real hardware, I cannot
test this on a valid device.

Looking through the code, I see that the the driver itself expects at lea=
st
pipes[ATH6KL_USB_PIPE_RX_DATA] #482, #484, #1188
pipes[ATH6KL_USB_PIPE_RX_DATA2] #1190
to be valid as they are accessed directly.

`hif_start` #677 seems to expect that all TX pipes are setup:
```
for (i =3D ATH6KL_USB_PIPE_TX_CTRL;
	     i <=3D ATH6KL_USB_PIPE_TX_DATA_HP; i++) {
		device->pipes[i].urb_cnt_thresh =3D
		    device->pipes[i].urb_alloc / 2;
	}
```
->
	ATH6KL_USB_PIPE_TX_CTRL =3D 0,
	ATH6KL_USB_PIPE_TX_DATA_LP,
	ATH6KL_USB_PIPE_TX_DATA_MP,
	ATH6KL_USB_PIPE_TX_DATA_HP,

But, there are other accesses to pipes[XXX] where XXX is passed into the
module from outside. I don't know the network stack well enough to infer
what values are passed in.

If we can assume that all pipes in `enum ATH6KL_USB_PIPE_ID` #30 are
setup, then we could simply iterate through the pipe array at the end of
`ath6kl_usb_setup_pipe_resources` and check that they are all non-NULL.

The simple (attached) fix is likely enough but someone with access to
the hardware may want to develop a more extensive fix.

Let me know what you think :)

Best,
Mathias and Hui

--------------A8C40E49416248C33B9CE440
Content-Type: text/x-patch;
 name="bug2-ath-usb.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="bug2-ath-usb.patch"

commit 7feca65b6481514ffadcd64905612d91d23fcd39
Author: Mathias Payer <mathias.payer@nebelwelt.net>
Date:   Tue Dec 18 11:12:28 2018 +0100

    Fix NULL deref in drivers/net/wireless/ath/ath{6kl|10k}/usb.c

    ath{6kl|10k}_usb_alloc_urb_from_pipe does not check if the pipe
    is valid and that is has been correctly allocated. Add a NULL
    check before accessing the pipe.

    Reported-by: Hui Peng <benquike@gmail.com>
    Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
    Signed-off-by: Hui Peng <benquike@gmail.com>
    Signed-off-by: Mathias Payer <mathias.payer@nebelwelt.net>

diff --git a/drivers/net/wireless/ath/ath10k/usb.c
b/drivers/net/wireless/ath/ath10k/usb.c
index f731d35ee76d..56d0bb57891b 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -49,6 +49,11 @@ ath10k_usb_alloc_urb_from_pipe(struct ath10k_usb_pipe =
*pipe)
  struct ath10k_urb_context *urb_context =3D NULL;
  unsigned long flags;

+ /* bail if this pipe is not allocated */
+ if (pipe->ar_usb =3D=3D NULL) {
+   return NULL;
+ }
+
  spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
  if (!list_empty(&pipe->urb_list_head)) {
    urb_context =3D list_first_entry(&pipe->urb_list_head,
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c
b/drivers/net/wireless/ath/ath6kl/usb.c
index 4defb7a0330f..64cd8825fcb7 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,11 @@ ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pip=
e *pipe)
  struct ath6kl_urb_context *urb_context =3D NULL;
  unsigned long flags;

+ /* bail if this pipe is not allocated */
+ if (pipe->ar_usb =3D=3D NULL) {
+   return NULL;
+ }
+
  spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
  if (!list_empty(&pipe->urb_list_head)) {
    urb_context =3D


--------------A8C40E49416248C33B9CE440
Content-Type: text/plain; charset=UTF-8;
 name="bug2_kasan-ath6kl-null-deref-bug.report"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bug2_kasan-ath6kl-null-deref-bug.report"

QlVHOiBLQVNBTjogbnVsbC1wdHItZGVyZWYgaW4gX19sb2NrX2FjcXVpcmUrMHg1YTgvMHgx
YjQwIGtlcm5lbC9sb2NraW5nL2xvY2tkZXAuYzozMzY1CgpDUFU6IDAgUElEOiA1NDk2IENv
bW06IHRlc3QgTm90IHRhaW50ZWQgNC4xNC44MSAjMQpIYXJkd2FyZSBuYW1lOiBRRU1VIFN0
YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBVYnVudHUtMS44LjItMXVi
dW50dTEgMDQvMDEvMjAxNApDYWxsIFRyYWNlOgogX19kdW1wX3N0YWNrIGxpYi9kdW1wX3N0
YWNrLmM6MTcgW2lubGluZV0KIGR1bXBfc3RhY2srMHhjMS8weDEyNyBsaWIvZHVtcF9zdGFj
ay5jOjUzCiBrYXNhbl9yZXBvcnRfZXJyb3IgbW0va2FzYW4vcmVwb3J0LmM6MzQ5IFtpbmxp
bmVdCiBrYXNhbl9yZXBvcnQuY29sZC42KzB4NmQvMHgyZDMgbW0va2FzYW4vcmVwb3J0LmM6
NDA5CiBjaGVja19tZW1vcnlfcmVnaW9uX2lubGluZSBtbS9rYXNhbi9rYXNhbi5jOjI2MCBb
aW5saW5lXQogX19hc2FuX2xvYWQ4KzB4NTQvMHg5MCBtbS9rYXNhbi9rYXNhbi5jOjY5NAog
X19sb2NrX2FjcXVpcmUrMHg1YTgvMHgxYjQwIGtlcm5lbC9sb2NraW5nL2xvY2tkZXAuYzoz
MzY1CiBsb2NrX2FjcXVpcmUrMHhjOS8weDIwMCBrZXJuZWwvbG9ja2luZy9sb2NrZGVwLmM6
Mzk5MQogX19yYXdfc3Bpbl9sb2NrX2lycXNhdmUgaW5jbHVkZS9saW51eC9zcGlubG9ja19h
cGlfc21wLmg6MTEwIFtpbmxpbmVdCiBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4NGEvMHg1
ZSBrZXJuZWwvbG9ja2luZy9zcGlubG9jay5jOjE2MAogYXRoNmtsX3VzYl9hbGxvY191cmJf
ZnJvbV9waXBlKzB4M2MvMHgxMzAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC91
c2IuYzoxMzUKIGF0aDZrbF91c2JfcG9zdF9yZWN2X3RyYW5zZmVycy5jb25zdHByb3AuMTAr
MHgxN2UvMHgyMTAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC91c2IuYzo0MTAK
IGF0aDZrbF91c2Jfc3RhcnRfcmVjdl9waXBlcyBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoNmtsL3VzYi5jOjQ4NCBbaW5saW5lXQogaGlmX3N0YXJ0IGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg2a2wvdXNiLmM6NjgyIFtpbmxpbmVdCiBhdGg2a2xfdXNiX3Bvd2VyX29u
KzB4NGIvMHhhMCBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL3VzYi5jOjEwNDEK
IGF0aDZrbF9oaWZfcG93ZXJfb24gZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC9o
aWYtb3BzLmg6MTM2IFtpbmxpbmVdCiBhdGg2a2xfY29yZV9pbml0KzB4MTE5LzB4N2MwIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvY29yZS5jOjk3CiBhdGg2a2xfdXNiX3By
b2JlKzB4NzQ4LzB4OGUwIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvdXNiLmM6
MTE0NwogdXNiX3Byb2JlX2ludGVyZmFjZSsweDFiNS8weDQ1MCBkcml2ZXJzL3VzYi9jb3Jl
L2RyaXZlci5jOjM2MQogcmVhbGx5X3Byb2JlIGRyaXZlcnMvYmFzZS9kZC5jOjQwNSBbaW5s
aW5lXQogZHJpdmVyX3Byb2JlX2RldmljZSsweDM4MS8weDQ2MCBkcml2ZXJzL2Jhc2UvZGQu
Yzo1NDkKIF9fZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHgxM2EvMHgxNjAgZHJpdmVycy9iYXNl
L2RkLmM6NjQ1CiBidXNfZm9yX2VhY2hfZHJ2KzB4ZGIvMHgxMzAgZHJpdmVycy9iYXNlL2J1
cy5jOjQ2MwogX19kZXZpY2VfYXR0YWNoKzB4MTRiLzB4MWQwIGRyaXZlcnMvYmFzZS9kZC5j
OjcwMgogZGV2aWNlX2luaXRpYWxfcHJvYmUrMHgxZi8weDMwIGRyaXZlcnMvYmFzZS9kZC5j
Ojc0OQogYnVzX3Byb2JlX2RldmljZSsweDE0YS8weDE2MCBkcml2ZXJzL2Jhc2UvYnVzLmM6
NTIzCiBkZXZpY2VfYWRkKzB4NTcwLzB4YWYwIGRyaXZlcnMvYmFzZS9jb3JlLmM6MTg0OQog
dXNiX3NldF9jb25maWd1cmF0aW9uKzB4ODc1LzB4Y2MwIGRyaXZlcnMvdXNiL2NvcmUvbWVz
c2FnZS5jOjE5NDcKIGdlbmVyaWNfcHJvYmUrMHg3ZC8weGIwIGRyaXZlcnMvdXNiL2NvcmUv
Z2VuZXJpYy5jOjE3NAogdXNiX3Byb2JlX2RldmljZSsweDY0LzB4YTAgZHJpdmVycy91c2Iv
Y29yZS9kcml2ZXIuYzoyNjYKIHJlYWxseV9wcm9iZSBkcml2ZXJzL2Jhc2UvZGQuYzo0MDUg
W2lubGluZV0KIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgzODEvMHg0NjAgZHJpdmVycy9iYXNl
L2RkLmM6NTQ5CiBfX2RldmljZV9hdHRhY2hfZHJpdmVyKzB4MTNhLzB4MTYwIGRyaXZlcnMv
YmFzZS9kZC5jOjY0NQogYnVzX2Zvcl9lYWNoX2RydisweGRiLzB4MTMwIGRyaXZlcnMvYmFz
ZS9idXMuYzo0NjMKIF9fZGV2aWNlX2F0dGFjaCsweDE0Yi8weDFkMCBkcml2ZXJzL2Jhc2Uv
ZGQuYzo3MDIKIGRldmljZV9pbml0aWFsX3Byb2JlKzB4MWYvMHgzMCBkcml2ZXJzL2Jhc2Uv
ZGQuYzo3NDkKIGJ1c19wcm9iZV9kZXZpY2UrMHgxNGEvMHgxNjAgZHJpdmVycy9iYXNlL2J1
cy5jOjUyMwogZGV2aWNlX2FkZCsweDU3MC8weGFmMCBkcml2ZXJzL2Jhc2UvY29yZS5jOjE4
NDkKIHVzYl9uZXdfZGV2aWNlKzB4NTg0LzB4ZDYwIGRyaXZlcnMvdXNiL2NvcmUvaHViLmM6
MjU0NAogaHViX3BvcnRfY29ubmVjdCBkcml2ZXJzL3VzYi9jb3JlL2h1Yi5jOjUwMDIgW2lu
bGluZV0KIGh1Yl9wb3J0X2Nvbm5lY3RfY2hhbmdlIGRyaXZlcnMvdXNiL2NvcmUvaHViLmM6
NTExNyBbaW5saW5lXQogcG9ydF9ldmVudCBkcml2ZXJzL3VzYi9jb3JlL2h1Yi5jOjUyMjMg
W2lubGluZV0KIGh1Yl9ldmVudF9pbXBsKzB4MTBiZS8weDFmODAgZHJpdmVycy91c2IvY29y
ZS9odWIuYzo1MzM1CiBodWJfZXZlbnQrMHgzOC8weDUwIGRyaXZlcnMvdXNiL2NvcmUvaHVi
LmM6NTIyMgogcHJvY2Vzc19vbmVfd29yaysweDk0NC8weDE1ZjAga2VybmVsL3dvcmtxdWV1
ZS5jOjIxMTIKIHdvcmtlcl90aHJlYWQrMHhlZi8weDEwZDAga2VybmVsL3dvcmtxdWV1ZS5j
OjIyNDYKIGt0aHJlYWQrMHgzNjcvMHg0MjAga2VybmVsL2t0aHJlYWQuYzoyMzgKIHJldF9m
cm9tX2ZvcmsrMHgyNC8weDMwIGFyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlM6NDM3CgpSSVA6
IDAwMzM6MHg0NTJkMDcKUlNQOiAwMDJiOjAwMDA3ZmZjYmIyZmY5NjggRUZMQUdTOiAwMDAw
MDIwMiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDAxMApSQVg6IGZmZmZmZmZmZmZmZmZmZGEg
UkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDAwMDAwMDQ1MmQwNwpSRFg6IDAwMDA3
ZmZjYmIyZmY5ODAgUlNJOiAwMDAwMDAwMGMwMTA1NTEyIFJESTogMDAwMDAwMDAwMDAwMDAw
MApSQlA6IDAwMDAwMDAwMjAwZjAwMDAgUjA4OiAwMDAwMDAwMDIwOTZjZmY4IFIwOTogMDAw
MDAwMDAyMDcxZmZhMgpSMTA6IDAwMDAwMDAwMDAwMDAwMDQgUjExOiAwMDAwMDAwMDAwMDAw
MjAyIFIxMjogMDAwMDAwMDAwMDAwMDAyNApSMTM6IDAwMDAwMDAwMjA5NmNmZjggUjE0OiAw
MDAwMDAwMDAwMDAwMDA0IFIxNTogMDAwMDAwMDAwMDAwMDAwMwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
--------------A8C40E49416248C33B9CE440--

--aRpgVMyzsTfPcwLLl5W62uYxu2iof3ntP--

--arZUooOvS0hpXnBrEabj3jHEhTQJstzuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE76knrakDUoqOLWcvTmM+8ToEiAgFAlwbckQACgkQTmM+8ToE
iAgxdg/+NmgWOYNYszhtqC9rSgYKjCXSLZ3XnY17lc1VlUS5ftiPE7CO5jSG/wp3
p/CoJuUqU0cx8JTJOr3046R9fGiJsx44euC2thdG3J56+WjuGNU1nQ5O8GymjXfx
2UPsumx/Sy7GAhkIsuZQwIyrGeHLF/benP8ON4Ue6Ax8fVs5MIf2cHixab1nPOyU
8f1qouTQu63i+yoh/hnNlwPWzRSmyfdJf3p+QZniIVDbQeoGk0l4yun+p0HKOREm
MXF9SGhHSu7k16sF87+0Q4N1D0Jfe2sEcORqv3pA2+WW1PBKoWbeL/ko4qhNcdPF
xzKs4gU289IN4moeC87mzqntSP+utEPXqqIzCgS/1HfC8SsVtQwlO2p1ndXk6C0B
6cXXieOBsr0BCnxDkaMHA2qAJF/0mWlT617N3Jvly7FPukeZ9OB7pSojunC67aFr
xUSdMHfYGp4O1SH3D4xJIK6bpfTssMG639wfLmIyYrq+0cQBUHW6TcTlqNOZAL7J
RgAVSsHB1bfitOI0Sp+uVpNX5uPWwcG8B81Ny3kk2NlUQmjbrSqL0FScsapxXTfC
VJ8dEubi7kSXSs0CSIPBS7+8SIQUAGRrKV1G9Eh06Y6ZH/ynzWDhoWryboHgxwYx
zRr9wtddPS6zw/dNU+z+y3xyIlNVqCDnIPQDHLmAVGtFNgBkM1E=
=SZsh
-----END PGP SIGNATURE-----

--arZUooOvS0hpXnBrEabj3jHEhTQJstzuF--
