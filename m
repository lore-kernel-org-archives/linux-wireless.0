Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:35226 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYJJB1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 21:27:19 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Fri, 10 Oct 2008 03:29:48 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <200810091858.17451.chunkeey@web.de> <48EEA432.7000605@lwfinger.net>
In-Reply-To: <48EEA432.7000605@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810100329.48890.chunkeey@web.de> (sfid-20081010_032730_392125_B2D1F11C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 October 2008 02:39:14 Larry Finger wrote:
> Christian Lamparter wrote:
> 
> As the original code got the data from bootrec, I kept it the same. On
> reflection, the statement above could be
> 
> priv->rx_mtu = le16_to_cpu(desc->rx_mtu);
> 
> I think which structure it is in is purely a matter of taste, but I will make
> that change, test it, and submit a new patch. The big-endian fix above will also
> need to be changed. I considered converting to a single struct using unions, but
> that would get pretty messy.
> 
> Larry

I finally found the definitions by Intersil (again):
> http://gxaafoot.homelinux.org/cgi-bin/archzoom.cgi/jean-baptiste.note@m4x.org--libre/prism54-usb--devo--0.0--patch-182/islsm_bra.h?diff=2
> tinyurl link: http://tinyurl.com/3wo45y
Unfortunately, back in 2002 noone though about big/little endian and 64bit :-D

/*
 * Each boot record is identified by a unique code, followed
 * by the length (in 32 bit words) of the data in the record. 
 */
struct s_bootrec_hdr {
	unsigned long code;
	unsigned long length;	
};

/* Generic bootrecord structure that can be mapped to each bootrecord */
struct s_bootrecord {
	struct s_bootrec_hdr hdr;
	char start_of_data;
};
[...]

so, what about changing bootrec to:
struct bootrec {
        __le32 code;
        __le32 len;
	char data[0];
} __attribute__((packed));
And put this endless discussion to rest

Regards,
	Chr
