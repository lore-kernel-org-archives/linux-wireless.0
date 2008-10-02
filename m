Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47690 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYJBNsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 09:48:24 -0400
Received: by gxk9 with SMTP id 9so1341739gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 06:48:22 -0700 (PDT)
Message-ID: <b25312890810020648i5e224f3cp1178790fd68d7f3b@mail.gmail.com> (sfid-20081002_154834_220380_D03B2C13)
Date: Thu, 2 Oct 2008 16:48:22 +0300
From: "Rami Rosen" <roszenrami@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] [RESEND] mac80211: remove redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c)
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1222954031.24551.51.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2860_2035525.1222955302544"
References: <eb3ff54b0810020556s407728b9n772e7ae178761eee@mail.gmail.com>
	 <1222954031.24551.51.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2860_2035525.1222955302544
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

 - This patch (against the linux-wireless-next git tree) removes a
redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c)
and adjust indentation in this method accordingly.

 In this method, there is no need to call again the
ieee80211_is_data() method; this is checked immediately before, in the
"if" command (we will not enter this block unless ieee80211_is_data()
is true, so that the "and" (&&) condition in that "if" command will be
fullfilled ).



Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>



On Thu, Oct 2, 2008 at 4:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-02 at 15:56 +0300, Rami Rosen wrote:
>> Hi,
>>
>>  - This patch (against the linux-wireless-next git tree) removes a
>> redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c).
>>
>>   In this method, there is no need to call again the
>> ieee80211_is_data() method; this is checked immediately before, in the
>> "if" command (we will not enter this block unless ieee80211_is_data()
>> is true, so that the "and" (&&) condition in that "if" command will be
>> fullfilled ).
>
> You should un-indent the code accordingly.
>
> johannes
>

------=_Part_2860_2035525.1222955302544
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fltfy7w41
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgwMjExL3R4LmMKaW5kZXgg
MGNjMmUyMy4uNjY3MzI1MiAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3R4LmMKKysrIGIvbmV0
L21hYzgwMjExL3R4LmMKQEAgLTEyOTYsMTYgKzEyOTYsMTQgQEAgaW50IGllZWU4MDIxMV9tYXN0
ZXJfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCiAJaWYgKGllZWU4MDIxMV92aWZf
aXNfbWVzaCgmb3NkYXRhLT52aWYpICYmCiAJICAgIGllZWU4MDIxMV9pc19kYXRhKGhkci0+ZnJh
bWVfY29udHJvbCkpIHsKLQkJaWYgKGllZWU4MDIxMV9pc19kYXRhKGhkci0+ZnJhbWVfY29udHJv
bCkpIHsKLQkJCWlmIChpc19tdWx0aWNhc3RfZXRoZXJfYWRkcihoZHItPmFkZHIzKSkKLQkJCQlt
ZW1jcHkoaGRyLT5hZGRyMSwgaGRyLT5hZGRyMywgRVRIX0FMRU4pOwotCQkJZWxzZQotCQkJCWlm
IChtZXNoX25leHRob3BfbG9va3VwKHNrYiwgb3NkYXRhKSkKLQkJCQkJcmV0dXJuICAwOwotCQkJ
aWYgKG1lbWNtcChvZGV2LT5kZXZfYWRkciwgaGRyLT5hZGRyNCwgRVRIX0FMRU4pICE9IDApCi0J
CQkJSUVFRTgwMjExX0lGU1RBX01FU0hfQ1RSX0lOQygmb3NkYXRhLT51Lm1lc2gsCi0JCQkJCQkJ
ICAgICBmd2RlZF9mcmFtZXMpOwotCQl9CisJCWlmIChpc19tdWx0aWNhc3RfZXRoZXJfYWRkciho
ZHItPmFkZHIzKSkKKwkJCW1lbWNweShoZHItPmFkZHIxLCBoZHItPmFkZHIzLCBFVEhfQUxFTik7
CisJCWVsc2UKKwkJCWlmIChtZXNoX25leHRob3BfbG9va3VwKHNrYiwgb3NkYXRhKSkKKwkJCQly
ZXR1cm4gIDA7CisJCWlmIChtZW1jbXAob2Rldi0+ZGV2X2FkZHIsIGhkci0+YWRkcjQsIEVUSF9B
TEVOKSAhPSAwKQorCQkJSUVFRTgwMjExX0lGU1RBX01FU0hfQ1RSX0lOQygmb3NkYXRhLT51Lm1l
c2gsCisJCQkJCQkJICAgIGZ3ZGVkX2ZyYW1lcyk7CiAJfSBlbHNlIGlmICh1bmxpa2VseShvc2Rh
dGEtPnZpZi50eXBlID09IE5MODAyMTFfSUZUWVBFX01PTklUT1IpKSB7CiAJCXN0cnVjdCBpZWVl
ODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRhOwogCQlzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2Nh
bCA9IG9zZGF0YS0+bG9jYWw7Cg==
------=_Part_2860_2035525.1222955302544--
