Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36522 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbESXGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 19:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <20150519230355.GA5853@gondor.apana.org.au>
References: <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au> <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220> <20150518200100.GY23057@wotan.suse.de>
 <1431981930.9091.29.camel@x220> <20150519000921.GA23057@wotan.suse.de>
 <1432022535.9091.48.camel@x220> <20150519154630.GB23057@wotan.suse.de>
 <20150519225945.GB5718@gondor.apana.org.au> <20150519230355.GA5853@gondor.apana.org.au>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 19 May 2015 16:05:43 -0700
Message-ID: <CAB=NE6XizmKMc80rLV9YTZGtEJdZ022+0HNPxXvunp5v4BnCMw@mail.gmail.com> (sfid-20150520_010624_004793_4DB43089)
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency when
 fw signing is enabled
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Kyle McMartin <kyle@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, jlee@suse.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 4:03 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> OK I was wrong.  It should still compile

Right.

> So I guess you only
> need the depends on/select for those that won't work without the
> firmware.

Well that's be true if FW_LOADER was easy to disable, but its not. You
really gotta try hard to disable it. Not only does it require EXPERT
but also EMBEDDED. I think its fair to say if you disable FW_LOADER
you know what you are doing and its fair for us then to remove such
selects or depends. Thoughts?

  Luis
