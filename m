Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:60953 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2JAP0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 11:26:09 -0400
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id GBmPKnzGf8VBD3DE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2012 11:13:58 -0400 (EDT)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 802.11w   bip_aad() bug ?
Date: Mon, 1 Oct 2012 15:13:56 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D075EB5FF@RockMX01.rock.corp> (sfid-20121001_172613_798023_EF8A5536)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gentlemen,

In kernel/net/mac80211/wpa.c function bip_add is as below (in the end).

I think the aad[1] should be 
aad[1] = skb->data[1] & ~(BIT(3) | BIT(4) | BIT(5));


Reference 1: ieee802.11-2012 page 1212
"FC-MPDU Frame Control field, with:
1) Retry bit (bit 11) masked to 0
2) Power Management bit (bit 12) masked to 0
3) More Data bit (bit 13) masked to 0"

Reference 2: ieee80211-2012, page 404, Figure 8-12

The bit 11 should be bit 3 of second byte.
The bit 12 should be bit 4 of second byte.
The bit 13 should be bit 5 of second byte.


What did I miss??



-------------------------------------
static void bip_aad(struct sk_buff *skb, u8 *aad)
{
    /* BIP AAD: FC(masked) || A1 || A2 || A3 */

    /* FC type/subtype */
    aad[0] = skb->data[0];
    /* Mask FC Retry, PwrMgt, MoreData flags to zero */
    aad[1] = skb->data[1] & ~(BIT(4) | BIT(5) | BIT(6));
    /* A1 || A2 || A3 */
    memcpy(aad + 2, skb->data + 4, 3 * ETH_ALEN);
}
