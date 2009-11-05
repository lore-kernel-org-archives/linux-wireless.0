Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35520 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZKEAQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 19:16:36 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so3762198ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 16:16:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911041445s4e69aa46nda01d423c1bd8f7d@mail.gmail.com>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com>
	 <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com>
	 <43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com>
	 <43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com>
	 <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com>
	 <20091104220034.GI10555@parisc-linux.org>
	 <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com>
	 <20091104221426.GA2599@bombadil.infradead.org>
	 <40f31dec0911041431i6f718bf1x1e52d9e12ab22060@mail.gmail.com>
	 <43e72e890911041445s4e69aa46nda01d423c1bd8f7d@mail.gmail.com>
Date: Thu, 5 Nov 2009 02:16:41 +0200
Message-ID: <40f31dec0911041616o1695e246x6347b14d558cfc05@mail.gmail.com>
Subject: Re: pci_set_mwi() and ath5k
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/5 Luis R. Rodriguez <mcgrof@gmail.com>:
>
> There are two cases where we can use the PCI_CACHE_LINE_SIZE:
>
> 1) Hardware has been designed to use it on some block to align some data somehow
> 2) Software uses it to align skb->data for performance/hw purposes
>
> I believe the second case can be handled by using L1_CACHE_BYTES
> instead and I'd at least like to change our common skb allocator to
> use that.
>
> The first case is where it seems there may be some skepticism as to
> whether or not hw really did not rely on it and I agree its safer to
> keep the programming of the  PCI_CACHE_LINE_SIZE in case it has a
> bogus value.
>
> Does this seem reasonable?
>
>  Luis
>

Yup, i believe 2 is the case, from what i've read the problem is that
we get corrupted data so i guess we can just use the L1_CACHE_BYTES to
align skb->data and not write anything to PCI_CACHE_LINE_SIZE if you
think that will work. Just be sure to test on some ath5k cards (don't
have time for anything right now ;-( ). I believe having cleaner code
is better than supporting an ancient chip anyway, if this is really
necessary for AR5210 -writing PCI_CACHE_LINE_SIZE- we can deal with it
later.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
