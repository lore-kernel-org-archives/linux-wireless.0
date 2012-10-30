Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 08:13:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TTAhE-0002Q5-2X
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 13:13:28 +0100
Message-ID: <1351599244.10097.10.camel@jlt4.sipsolutions.net> (sfid-20121030_131334_936596_4B8EDA54)
Subject: Re: [RFC v2] wireless: add utility function to get P2P attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 13:14:04 +0100
In-Reply-To: <1351598047-20957-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_125338_711307_23F87F9A)
References: <1351536651-3176-1-git-send-email-johannes@sipsolutions.net>
	 <1351598047-20957-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121030_125338_711307_23F87F9A)
Content-Type: multipart/mixed; boundary="=-EVXvht9tpm+bpheIOhD5"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EVXvht9tpm+bpheIOhD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2012-10-30 at 12:54 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Parsing the P2P attributes can be tricky as their
> contents can be split across multiple (vendor) IEs.
> Thus, it's not possible to parse them like IEs (by
> returning a pointer to the data.) Instead, provide
> a function that copies the attribute data into a
> caller-provided buffer and returns the size needed
> (useful in case the buffer was too small.)

Attached is the code I used to test this.

johannes

--=-EVXvht9tpm+bpheIOhD5
Content-Disposition: attachment; filename="test.c"
Content-Type: text/x-csrc; name="test.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <string.h>
#include <linux/types.h>
#include <stdio.h>
#include <stdbool.h>

typedef unsigned short u16;
typedef unsigned char u8;

#define EILSEQ 20
#define ENOENT 10
#define WLAN_EID_VENDOR_SPECIFIC 0xdd

#define min_t(t, a, b)	((t)(a) < (t)(b) ? (t)(a) : (t)(b))
#define min(a, b)	((a) < (b) ? (a) : (b))

static inline u16 get_unaligned_le16(const void *p)
{
	const u8 *_p = p;
	return _p[0] | _p[1] << 8;
}

unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
				   u8 attr, u8 *buf, unsigned int bufsize)
{
	u8 *out = buf;
	u16 attr_remaining = 0, attr_hdr_remaining = 0;
	bool desired_attr = false;
	u16 desired_len = 0;

	while (len > 0) {
		unsigned int iedatalen;
		unsigned int copy;
		const u8 *iedata;
		u8 attr_hdr[3];

		if (len < 2)
			return -EILSEQ;
		iedatalen = ies[1];
		if (iedatalen + 2 > len)
			return -EILSEQ;

		if (ies[0] != WLAN_EID_VENDOR_SPECIFIC)
			goto cont;

		if (iedatalen < 4)
			goto cont;

		iedata = ies + 2;

		/* check WFA OUI, P2P subtype */
		if (iedata[0] != 0x50 || iedata[1] != 0x6f ||
		    iedata[2] != 0x9a || iedata[3] != 0x09)
			goto cont;

		iedatalen -= 4;
		iedata += 4;

		while (iedatalen > 0) {
			if (attr_hdr_remaining) {
				copy = min_t(unsigned int, iedatalen,
							   attr_hdr_remaining);

				memcpy(attr_hdr + 3 - attr_hdr_remaining,
				       iedata, copy);
				attr_hdr_remaining -= copy;
				iedata += copy;
				iedatalen -= copy;
				if (attr_hdr_remaining)
					break;
				desired_attr = attr_hdr[0] == attr;
				attr_remaining =
					get_unaligned_le16(attr_hdr + 1);
			} else if (attr_remaining == 0) {
				/* next attribute starts */
				if (iedatalen < 3) {
					memcpy(attr_hdr, iedata, iedatalen);
					attr_hdr_remaining = 3 - iedatalen;
					break;
				}
				desired_attr = iedata[0] == attr;
				attr_remaining = get_unaligned_le16(iedata + 1);
				iedatalen -= 3;
				iedata += 3;
			}

			copy = min_t(unsigned int, attr_remaining, iedatalen);

			if (desired_attr) {
				desired_len += copy;
				if (out && copy && bufsize) {
					memcpy(out, iedata, min(bufsize, copy));
					out += min(bufsize, copy);
					bufsize -= min(bufsize, copy);
				}

				if (copy == attr_remaining)
					return desired_len;
			}

			iedata += copy;
			iedatalen -= copy;
			attr_remaining -= copy;
		}

 cont:
		len -= ies[1] + 2;
		ies += ies[1] + 2;
	}

	if (attr_remaining || attr_hdr_remaining)
		return -EILSEQ;

	return -ENOENT;
}

static const u8 test_ies[] = {
	/* 0xA0 - split data */
	0xdd, 0x08, 0x50, 0x6f, 0x9a, 0x09, 0xA0, 0x03, 0x00, 0xDD,
		0xdd, 0x06, 0x50, 0x6f, 0x9a, 0x09, 0xDD, 0xDD,
	/* 0xA1 - empty P2P IE before it */
	0xdd, 0x04, 0x50, 0x6f, 0x9a, 0x09,
		0xdd, 0x08, 0x50, 0x6f, 0x9a, 0x09, 0xA1, 0x01, 0x00, 0xdd,
	/* 0xA2 - P2P IE split after attribute ID */
	0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0xA2,
		0xdd, 0x07, 0x50, 0x6f, 0x9a, 0x09, 0x01, 0x00, 0xdd,
	/* 0xA3 - P2P IE split inside attribute length field */
	0xdd, 0x06, 0x50, 0x6f, 0x9a, 0x09, 0xA3, 0x01,
		0xdd, 0x06, 0x50, 0x6f, 0x9a, 0x09, 0x00, 0xdd,
	/* 0xA4 - P2P IE split after attribute length field */
	0xdd, 0x07, 0x50, 0x6f, 0x9a, 0x09, 0xA4, 0x01, 0x00,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0xdd,
	/* 0xA5 - P2P IE split over multiple IEs */
	0xdd, 0x06, 0x50, 0x6f, 0x9a, 0x09, 0xA5, 0x07,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x00,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x01,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x02,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x03,
		0xdd, 0x06, 0x50, 0x6f, 0x9a, 0x09, 0x04, 0x05,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x06,
		0xdd, 0x05, 0x50, 0x6f, 0x9a, 0x09, 0x07,
	/* 0xA6 - zero-length P2P IE */
	0xdd, 0x07, 0x50, 0x6f, 0x9a, 0x09, 0xA6, 0x00, 0x00,
};

int main()
{
	int ret, i, search;
	u8 buf[200];

	for (search = 0xA0; search <= 0xA7; search++) {
		ret = cfg80211_get_p2p_attr(test_ies, sizeof(test_ies),
					    search, buf, sizeof(buf));

		printf("search 0x%.2X, ret = %d\n", search, ret);
		if (ret > 0) {
			printf("\tresult:");
			for (i = 0; i < ret; i++)
				printf(" %.2x", buf[i]);
			printf("\n");
		}
	}
}

--=-EVXvht9tpm+bpheIOhD5--

