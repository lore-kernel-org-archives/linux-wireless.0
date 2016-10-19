Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16877 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944463AbcJSPR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:17:26 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: sequence diagrams in rst documentation
In-Reply-To: <40E20C55-88BE-4639-9901-E4073A07713B@darmarit.de>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de> <1476799968.6425.33.camel@sipsolutions.net> <87eg3dvhdi.fsf@intel.com> <40E20C55-88BE-4639-9901-E4073A07713B@darmarit.de>
Date: Wed, 19 Oct 2016 18:17:20 +0300
Message-ID: <87twc8l667.fsf@intel.com> (sfid-20161019_171751_713865_33F7C096)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 19 Oct 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Am 18.10.2016 um 16:52 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
>
>>> *Only* adding the PNG would be awful, I'd have to keep track of the
>>> corresponding source elsewhere, and perhaps couldn't even GPL it
>>> because then I couldn't distribute the PNG without corresponding
>>> source...
>>> 
>>> Adding the source text would really be the only practical choice, but
>>> doing so makes it easy to mismatch things, and also very easy to use
>>> proprietary services for it that may go away at any time, etc.
>> 
>> Agreed. And there are other problems with attaching binaries (although
>> I'd say we should fix them too) [1].
>> 
>> [1] http://lkml.kernel.org/r/02a78907-933d-3f61-572e-28154b16b9e5@redhat.com
>
> Hmm, I was not briefed that binaries are problematic. I have seen
> GIFs e.g. [2] and PDFs with a long history (when I worked with the media
> documentation), so I thought binaries are OK.
>
> Can you give me some more hints to understand in what ways they are
> problematic?  / sorry if my question seems dump /

You can download incremental patches from https://www.kernel.org/ for
kernel updates. Seems so 90s, but people apparently still do this. I
don't think the traditional diff/patch tools play ball with
binaries. The least that could be done is to generate the patches using
git diff --binary to include the git binary diff format. I don't see how
that would be worse than having just "Binary files foo and bar differ"
in the diff.

Personally I don't really mind including binaries if they are the
*source* format. If they're generated from something else, that
something else should be tracked in git instead.

And Someone(tm) should fix the tooling to handle binaries...

BR,
Jani.


>
> [2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/Documentation/DocBook/v4l/fieldseq_tb.gif?h=v3.0
>
> -- Markus --

-- 
Jani Nikula, Intel Open Source Technology Center
