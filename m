Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33410 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZKECzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 21:55:45 -0500
Received: by bwz27 with SMTP id 27so9622416bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 18:55:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091104221426.GA2599@bombadil.infradead.org>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com>
	 <40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com>
	 <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com>
	 <43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com>
	 <43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com>
	 <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com>
	 <20091104220034.GI10555@parisc-linux.org>
	 <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com>
	 <20091104221426.GA2599@bombadil.infradead.org>
Date: Wed, 4 Nov 2009 21:55:49 -0500
Message-ID: <b6c5339f0911041855m4f2ee750j31ff46ad92b7b7bc@mail.gmail.com>
Subject: Re: pci_set_mwi() and ath5k
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 5:14 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> -               off = ((unsigned long) skb->data) % common->cachelsz;
> +               off = ((unsigned long) skb->data) % L1_CACHE_BYTES;
>                if (off != 0)

Side note, at least this needs to use PTR_ALIGN :)

I have a patch somewhere to do that but if you're in there anyway...

-- 
Bob Copeland %% www.bobcopeland.com
