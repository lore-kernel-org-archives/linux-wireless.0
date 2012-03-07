Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37820 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab2CGQPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 11:15:55 -0500
Received: by gghe5 with SMTP id e5so2225392ggh.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 08:15:53 -0800 (PST)
Message-ID: <4F5789B5.1050505@lwfinger.net> (sfid-20120307_171624_068103_29A03DD5)
Date: Wed, 07 Mar 2012 10:15:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <27728117.2989270.1331098305793.JavaMail.root@vznit170060>
In-Reply-To: <27728117.2989270.1331098305793.JavaMail.root@vznit170060>
Content-Type: multipart/mixed;
 boundary="------------090703010006060407050708"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090703010006060407050708
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/06/2012 11:31 PM, alupu@verizon.net wrote:
>> On 03/06/12 10:22 PM, Larry Finger wrote:>  Here are the details for my system, which is 64-bit.
>> I'm running kernel 3.3-rc5 with wireless-tools version 30.
>
> The root of the divergence between our results might be
> found in the differences between my version 29 and your "30".
>
> According to Jean Tourrilhes (the founding father of the tools):
> "The latest stable version of Wireless Tools is version 29"
> He also mentions (and offers) a version "30-pre9(beta)".
> See
> <www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>
>
> As an aside, this situation where distributions (as opposed to the
> (B)LFS approach) tweak packages so as to offer an overall workable
> release is getting worse and worse, especially lately where
> software package dependencies are getting way out of hand.
> In this particular instance, we'll never know if openSuse "30"
> is the same as "30-pre9(beta)" (whatever that would mean) or
> a lower "-pre" or even an in-house version 29/30 software
> massaged to play nice with other package instances within
> a particular distribution release.
>
> That said, this doesn't mean that my problem might not lie elsewhere.
> A great help would be if you could install the latest
> _stable_ release (29) and quickly test my complaints.
> Don't be afraid of the version police. You cannot be arrested
> for using the _official_, genuine, latest stable version 29.
> You _might_ get in trouble if they catch you using a most
> likely counterfeit version 30 :)
>
>> What would be the ifconfig command to start the interface with DHCP?
>> In my distro, we have an ifup command that reads a configuration file.
>> That script is too complicated to see what it does.
>
> I've used DHCP only for "wire" connections, in a wrapper of my
> own which finally ends up doing something like,
>   dhcpcd eth0 -L

Well, despite your complaints about my "illicit and counterfeit" version of 
wireless extensions, that is not where the problem lies, as shown in the 
attached log. In it, I used kernel 3.3-rc6 to configure the r8712u device, get 
an IP using the dhcpcd command, and pinged the Internet. I was even able to 
split the setting of the essid and the key.

To help debug the problem, the attached patch will log the setting of the ESSID 
in the driver. For some reason, there is one garbage printout and the correct 
one for every call, but that should not cause a problem.

Larry

--------------090703010006060407050708
Content-Type: text/plain;
 name="wlan4_log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="wlan4_log"

bGludXgtZ3NrZDovaG9tZS9maW5nZXIvd2lyZWxlc3NfdG9vbHMuMjkgIyBpd2NvbmZpZyAt
LXZlcnNpb24KaXdjb25maWcgIFdpcmVsZXNzLVRvb2xzIHZlcnNpb24gMjkKICAgICAgICAg
IENvbXBhdGlibGUgd2l0aCBXaXJlbGVzcyBFeHRlbnNpb24gdjExIHRvIHYyMi4KCktlcm5l
bCAgICBDdXJyZW50bHkgY29tcGlsZWQgd2l0aCBXaXJlbGVzcyBFeHRlbnNpb24gdjIyLgoK
d2xhbjQgICAgIFJlY29tbWVuZCBXaXJlbGVzcyBFeHRlbnNpb24gdjE2IG9yIGxhdGVyLAog
ICAgICAgICAgQ3VycmVudGx5IGNvbXBpbGVkIHdpdGggV2lyZWxlc3MgRXh0ZW5zaW9uIHYy
Mi4KCmxpbnV4LWdza2Q6L2hvbWUvZmluZ2VyL3dpcmVsZXNzX3Rvb2xzLjI5ICMgaXdjb25m
aWcgd2xhbjQKd2xhbjQgICAgIHVuYXNzb2NpYXRlZCAgTmlja25hbWU6InJ0bF93aWZpIgog
ICAgICAgICAgTW9kZTpNYW5hZ2VkICBBY2Nlc3MgUG9pbnQ6IE5vdC1Bc3NvY2lhdGVkICAg
U2Vuc2l0aXZpdHk6MC8wICAKICAgICAgICAgIFJldHJ5Om9mZiAgIFJUUyB0aHI6b2ZmICAg
RnJhZ21lbnQgdGhyOm9mZgogICAgICAgICAgRW5jcnlwdGlvbiBrZXk6b2ZmCiAgICAgICAg
ICBQb3dlciBNYW5hZ2VtZW50Om9mZgogICAgICAgICAgTGluayBRdWFsaXR5OjAgIFNpZ25h
bCBsZXZlbDowICBOb2lzZSBsZXZlbDowCiAgICAgICAgICBSeCBpbnZhbGlkIG53aWQ6MCAg
UnggaW52YWxpZCBjcnlwdDowICBSeCBpbnZhbGlkIGZyYWc6MAogICAgICAgICAgVHggZXhj
ZXNzaXZlIHJldHJpZXM6MCAgSW52YWxpZCBtaXNjOjAgICBNaXNzZWQgYmVhY29uOjAKCmxp
bnV4LWdza2Q6L2hvbWUvZmluZ2VyL3dpcmVsZXNzX3Rvb2xzLjI5ICMgaXdjb25maWcgd2xh
bjQgZXNzaWQgcmFkaXVzCmxpbnV4LWdza2Q6L2hvbWUvZmluZ2VyL3dpcmVsZXNzX3Rvb2xz
LjI5ICMgaXdjb25maWcgd2xhbjQKd2xhbjQgICAgIElFRUUgODAyLjExYmcgIEVTU0lEOiJy
YWRpdXMiICBOaWNrbmFtZToicnRsX3dpZmkiCiAgICAgICAgICBNb2RlOk1hbmFnZWQgIEZy
ZXF1ZW5jeToyLjQxMiBHSHogIEFjY2VzcyBQb2ludDogMDA6MTQ6QkY6ODU6NDk6RkEgICAK
ICAgICAgICAgIEJpdCBSYXRlOjU0IE1iL3MgICBTZW5zaXRpdml0eTowLzAgIAogICAgICAg
ICAgUmV0cnk6b2ZmICAgUlRTIHRocjpvZmYgICBGcmFnbWVudCB0aHI6b2ZmCiAgICAgICAg
ICBFbmNyeXB0aW9uIGtleTpvZmYKICAgICAgICAgIFBvd2VyIE1hbmFnZW1lbnQ6b2ZmCiAg
ICAgICAgICBMaW5rIFF1YWxpdHk9MTAwLzEwMCAgU2lnbmFsIGxldmVsPTEwMC8xMDAgIE5v
aXNlIGxldmVsPTAvMTAwCiAgICAgICAgICBSeCBpbnZhbGlkIG53aWQ6MCAgUnggaW52YWxp
ZCBjcnlwdDowICBSeCBpbnZhbGlkIGZyYWc6MAogICAgICAgICAgVHggZXhjZXNzaXZlIHJl
dHJpZXM6MCAgSW52YWxpZCBtaXNjOjAgICBNaXNzZWQgYmVhY29uOjAKCmxpbnV4LWdza2Q6
L2hvbWUvZmluZ2VyL3dpcmVsZXNzX3Rvb2xzLjI5ICMgaXdjb25maWcgd2xhbjQga2V5IHJl
c3RyaWN0ZWQgMTIzNGYwMDMzZWRhZWJmM2Y3ZGFiNGNlY2EKbGludXgtZ3NrZDovaG9tZS9m
aW5nZXIvd2lyZWxlc3NfdG9vbHMuMjkgIyBpd2NvbmZpZyB3bGFuNAp3bGFuNCAgICAgSUVF
RSA4MDIuMTFiZyAgRVNTSUQ6InJhZGl1cyIgIE5pY2tuYW1lOiJydGxfd2lmaSIKICAgICAg
ICAgIE1vZGU6TWFuYWdlZCAgRnJlcXVlbmN5OjIuNDEyIEdIeiAgQWNjZXNzIFBvaW50OiAw
MDoxNDpCRjo4NTo0OTpGQSAgIAogICAgICAgICAgQml0IFJhdGU6NTQgTWIvcyAgIFNlbnNp
dGl2aXR5OjAvMCAgCiAgICAgICAgICBSZXRyeTpvZmYgICBSVFMgdGhyOm9mZiAgIEZyYWdt
ZW50IHRocjpvZmYKICAgICAgICAgIEVuY3J5cHRpb24ga2V5OjEyMzQtRjAwMy0zRURBLUVC
RjMtRjdEQS1CNENFLUNBICAgU2VjdXJpdHkgbW9kZTpyZXN0cmljdGVkCiAgICAgICAgICBQ
b3dlciBNYW5hZ2VtZW50Om9mZgogICAgICAgICAgTGluayBRdWFsaXR5PTEwMC8xMDAgIFNp
Z25hbCBsZXZlbD0xMDAvMTAwICBOb2lzZSBsZXZlbD0wLzEwMAogICAgICAgICAgUnggaW52
YWxpZCBud2lkOjAgIFJ4IGludmFsaWQgY3J5cHQ6MCAgUnggaW52YWxpZCBmcmFnOjAKICAg
ICAgICAgIFR4IGV4Y2Vzc2l2ZSByZXRyaWVzOjAgIEludmFsaWQgbWlzYzowICAgTWlzc2Vk
IGJlYWNvbjowCgpsaW51eC1nc2tkOi9ob21lL2Zpbmdlci93aXJlbGVzc190b29scy4yOSAj
IGRoY3BjZCB3bGFuNCAtTApsaW51eC1nc2tkOi9ob21lL2Zpbmdlci93aXJlbGVzc190b29s
cy4yOSAjIGlmY29uZmlnIHdsYW40CndsYW40ICAgICBMaW5rIGVuY2FwOkV0aGVybmV0ICBI
V2FkZHIgMDA6MjY6NUE6QkY6NDE6RTQgIAogICAgICAgICAgaW5ldCBhZGRyOjE5Mi4xNjgu
My4xMTAgIEJjYXN0OjE5Mi4xNjguMy4yNTUgIE1hc2s6MjU1LjI1NS4yNTUuMAogICAgICAg
ICAgVVAgQlJPQURDQVNUIFJVTk5JTkcgTVVMVElDQVNUICBNVFU6MTUwMCAgTWV0cmljOjEK
ICAgICAgICAgIFJYIHBhY2tldHM6MTYxMyBlcnJvcnM6MCBkcm9wcGVkOjE2MCBvdmVycnVu
czowIGZyYW1lOjAKICAgICAgICAgIFRYIHBhY2tldHM6MzQxIGVycm9yczowIGRyb3BwZWQ6
MCBvdmVycnVuczowIGNhcnJpZXI6MAogICAgICAgICAgY29sbGlzaW9uczowIHR4cXVldWVs
ZW46MTAwMCAKICAgICAgICAgIFJYIGJ5dGVzOjY5OTMxNCAoNjgyLjkgS2IpICBUWCBieXRl
czo1NjEwMCAoNTQuNyBLYikKCmxpbnV4LWdza2Q6L2hvbWUvZmluZ2VyL3dpcmVsZXNzX3Rv
b2xzLjI5ICMgcGluZyAtYzMgd3d3LnNhbWJhLm9yZwpQSU5HIGZuLnNhbWJhLm9yZyAoMjE2
LjgzLjE1NC4xMDYpIDU2KDg0KSBieXRlcyBvZiBkYXRhLgo2NCBieXRlcyBmcm9tIGZuLnNh
bWJhLm9yZyAoMjE2LjgzLjE1NC4xMDYpOiBpY21wX3NlcT0xIHR0bD00NyB0aW1lPTgzLjgg
bXMKNjQgYnl0ZXMgZnJvbSBmbi5zYW1iYS5vcmcgKDIxNi44My4xNTQuMTA2KTogaWNtcF9z
ZXE9MiB0dGw9NDcgdGltZT03OS4wIG1zCjY0IGJ5dGVzIGZyb20gZm4uc2FtYmEub3JnICgy
MTYuODMuMTU0LjEwNik6IGljbXBfc2VxPTMgdHRsPTQ3IHRpbWU9NzYuNiBtcwoKLS0tIGZu
LnNhbWJhLm9yZyBwaW5nIHN0YXRpc3RpY3MgLS0tCjMgcGFja2V0cyB0cmFuc21pdHRlZCwg
MyByZWNlaXZlZCwgMCUgcGFja2V0IGxvc3MsIHRpbWUgMjAwMW1zCnJ0dCBtaW4vYXZnL21h
eC9tZGV2ID0gNzYuNjQwLzc5Ljg1MC84My44NDAvMi45OTkgbXMKCg==
--------------090703010006060407050708
Content-Type: text/plain;
 name="r8712u_debug_SIOC"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="r8712u_debug_SIOC"

SW5kZXg6IHN0YWdpbmcvZHJpdmVycy9zdGFnaW5nL3J0bDg3MTIvcnRsODcxeF9pb2N0bF9s
aW51eC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIHN0YWdpbmcub3JpZy9kcml2ZXJzL3N0YWdpbmcv
cnRsODcxMi9ydGw4NzF4X2lvY3RsX2xpbnV4LmMKKysrIHN0YWdpbmcvZHJpdmVycy9zdGFn
aW5nL3J0bDg3MTIvcnRsODcxeF9pb2N0bF9saW51eC5jCkBAIC0xMjkzLDEyICsxMjkzLDE4
IEBAIHN0YXRpYyBpbnQgcjg3MTFfd3hfc2V0X2Vzc2lkKHN0cnVjdCBuZXQKIAlzdHJ1Y3Qg
bGlzdF9oZWFkICpwaGVhZDsKIAl1MzIgbGVuOwogCi0JaWYgKGNoZWNrX2Z3c3RhdGUocG1s
bWVwcml2LCBfRldfVU5ERVJfU1VSVkVZKSkKKwlpZiAoY2hlY2tfZndzdGF0ZShwbWxtZXBy
aXYsIF9GV19VTkRFUl9TVVJWRVkpKSB7CisJCXByaW50ayhLRVJOX0lORk8gIioqKioqKioq
KioqIGluICVzIC0gUmV0dXJuZWQgLUVCVVNZXG4iLCBfX2Z1bmNfXyk7CiAJCXJldHVybiAt
RUJVU1k7Ci0JaWYgKGNoZWNrX2Z3c3RhdGUocG1sbWVwcml2LCBfRldfVU5ERVJfTElOS0lO
RykpCisJfQorCWlmIChjaGVja19md3N0YXRlKHBtbG1lcHJpdiwgX0ZXX1VOREVSX0xJTktJ
TkcpKSB7CisJCXByaW50ayhLRVJOX0lORk8gIioqKioqKioqKioqIGluICVzIC0gUmV0dXJu
ZWQgMFxuIiwgX19mdW5jX18pOwogCQlyZXR1cm4gMDsKLQlpZiAod3JxdS0+ZXNzaWQubGVu
Z3RoID4gSVdfRVNTSURfTUFYX1NJWkUpCisJfQorCWlmICh3cnF1LT5lc3NpZC5sZW5ndGgg
PiBJV19FU1NJRF9NQVhfU0laRSkgeworCQlwcmludGsoS0VSTl9JTkZPICIqKioqKioqKioq
KiBpbiAlcyAtIFJldHVybmVkIC1FMkJJR1xuIiwgX19mdW5jX18pOwogCQlyZXR1cm4gLUUy
QklHOworCX0KIAlhdXRobW9kZSA9IHBhZGFwdGVyLT5zZWN1cml0eXByaXYubmRpc2F1dGh0
eXBlOwogCWlmICh3cnF1LT5lc3NpZC5mbGFncyAmJiB3cnF1LT5lc3NpZC5sZW5ndGgpIHsK
IAkJbGVuID0gKHdycXUtPmVzc2lkLmxlbmd0aCA8IElXX0VTU0lEX01BWF9TSVpFKSA/CkBA
IC0xMzM4LDYgKzEzNDQsNyBAQCBzdGF0aWMgaW50IHI4NzExX3d4X3NldF9lc3NpZChzdHJ1
Y3QgbmV0CiAJCX0KIAkJcjg3MTJfc2V0XzgwMl8xMV9hdXRoZW50aWNhdGlvbl9tb2RlKHBh
ZGFwdGVyLCBhdXRobW9kZSk7CiAJCXI4NzEyX3NldF84MDJfMTFfc3NpZChwYWRhcHRlciwg
Jm5kaXNfc3NpZCk7CisJCXByaW50ayhLRVJOX0lORk8gInI4NzEydTogU2V0IEVTU0lEIHRv
ICVzXG4iLCBuZGlzX3NzaWQuU3NpZCk7CiAJfQogCXJldHVybiAtRUlOUFJPR1JFU1M7CiB9
Cg==
--------------090703010006060407050708--
