Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62991 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2DXGl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 02:41:27 -0400
Received: by obbta14 with SMTP id ta14so667297obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 23:41:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335246611.3447.0.camel@jlt3.sipsolutions.net>
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org> <1335246611.3447.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 23 Apr 2012 23:41:04 -0700
Message-ID: <CAB=NE6VseLtuxLYZcb3c9B+d+834_0bazN-db0EoJdVTBhsSZA@mail.gmail.com> (sfid-20120424_084133_563487_DFAB6B14)
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2012 at 10:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-04-23 at 19:36 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
>>
>> pr_fmt() is either defined or we redefine it. Typically
>> drivers define it prior to including printk.h but this
>> is done under the assumption that no other subsystem
>> it uses has already defined pr_fmt(). In such cases
>> pr_fmt() should be undefined and redefined.
>>
>> Doing this properly shaves down compilation time quite
>> considerably.
>
>> --- a/drivers/net/wireless/ath/ath5k/ani.c
>> +++ b/drivers/net/wireless/ath/ath5k/ani.c
>> @@ -14,8 +14,11 @@
>>   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>   */
>>
>> +#undef pr_fmt
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> I understand this is right for compat, but is it really also needed in
> mainline?

I've seen drivers do this, drivers/net/wireless/mwifiex/decl.h was
where I got the hint of doing this actually.

> I was under the impression there we never defined pr_fmt in
> header files.

I think this is a good assumption, but it can easily and sloppily hold
to not be true. In fact, I'm thinking it may make sense to add a
helper to do this uniformly across the kernel.

  Luis
