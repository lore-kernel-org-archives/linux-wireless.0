Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:35210 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdGQRkJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 13:40:09 -0400
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
From: Ian Molton <ian@mnementh.co.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170716112129.10206-1-ian@mnementh.co.uk>
 <72fae7cb-7db0-4979-8e4b-cf26c557634a@broadcom.com>
 <97ac668c-fef4-37be-06e1-0135dea77527@mnementh.co.uk>
Message-ID: <3f51e5bb-c0ea-6c56-66e2-f5fd170bc7c4@mnementh.co.uk> (sfid-20170717_194013_104400_0D519E0E)
Date: Mon, 17 Jul 2017 18:40:07 +0100
MIME-Version: 1.0
In-Reply-To: <97ac668c-fef4-37be-06e1-0135dea77527@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 16:56, Ian Molton wrote:
> The two structures *always* exist together. And yes, preventing access
> to the members that we don't want accessed from the wrong layer would
> be *possibly* worthwhile, however the driver code as it stands
> *constantly* short circuits that with the use of offsetof().

inb4: misthought there - it doesnt use offsetof() for that, but my point
stands.

Look, for example, at the core structs:

struct brcmf_core_priv {
	struct brcmf_core pub;
	u32 wrapbase;
	struct list_head list;
	struct brcmf_chip_priv *chip;
};

and

struct brcmf_core {
 	u16 id;
 	u16 rev;
 	u32 base;
}


What is the useful separation being achieved here? both base and
wrapbase are pointers to core address space.

Apart from that, nothing but the core ID and revision are separated from
the other data.

so we have two address space pointers, which are separated for no good
reason, and two derived values which its pretty much irrelevant if
they're changed.

The only other information in there is the list management structures,
which are used in public structures throughout the linux kernel - its
common practice.

A quick grep shows that the struct brcmf_core does not get used outside
chip.c, and struct brcmf_chip is used purely as a pointer in a less than
a handful of places in the bus drivers, which are barely interested in
their internal data (chiprev, etc.).

For these tiny number of cases do we really want to make all of chip.c
and chip.h illegible?

eg:

-	chip->ops->activate(chip->ctx, &chip->pub, rstvec);
+	chip->ops->activate(chip->ctx, chip, rstvec);

Which I was planning to submit a further patch to convert it to simply:

chip->ops->activate(chip, rstvec);

Which is *so* much more readable.

-Ian
