Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28509.mail.ukl.yahoo.com ([87.248.110.188]:20944 "HELO
	web28509.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750900AbYKAUsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 16:48:21 -0400
Date: Sat, 1 Nov 2008 20:48:19 +0000 (GMT)
From: Julien HENRY <henryju@yahoo.fr>
Subject: Re : Not associated with Intel 4965
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-666318808-1225572499=:58975"
Message-ID: <170039.58975.qm@web28509.mail.ukl.yahoo.com> (sfid-20081101_214835_172635_45CE5AF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0-666318808-1225572499=:58975
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> We no longer have iwl4965, the new name is iwlagn, try that.=0A=0ANot bet=
ter (please note that I've upgraded to kernel 2.6.27.4-desktop-0.uc1mnb sin=
ce my last post):=0A=0A# modprobe iwlagn=0AWARNING: Error inserting iwlcore=
 (/lib/modules/2.6.27.4-desktop-0.uc1mnb/updates/drivers/net/wireless/iwlwi=
fi/iwlcore.ko): Unknown symbol in module, or unknown parameter (see dmesg)=
=0AFATAL: Error inserting iwlagn (/lib/modules/2.6.27.4-desktop-0.uc1mnb/ke=
rnel/drivers/net/wireless/iwlwifi/iwlagn.ko.gz): Unknown symbol in module, =
or unknown parameter (see dmesg)=0A=0AFor your information, with my genuine=
 kernel module, I had the following infos:=0A# wpa_cli status=0ASelected in=
terface 'wlan0'             =0Abssid=3D1a:66:de:7a:ae:dc                =0A=
ssid=3DMiddleEarth                       =0Aid=3D0                         =
          =0Apairwise_cipher=3DCCMP                   =0Agroup_cipher=3DTKI=
P                      =0Akey_mgmt=3DWPA-PSK                       =0Awpa_s=
tate=3DCOMPLETED=0A=0A# iwconfig wlan0 essid "MiddleEarth" key s:XXXXXXX=0A=
Error for wireless request "Set Encode" (8B2A) :=0A    SET failed on device=
 wlan0 ; Invalid argument.=0A=0Aand still Not-Associated=0A=0ADo you know s=
omething I can try to find the solution? Thanks for your help.=0A=0AJulien=
=0A=0A=0A=0A----- Message d'origine ----=0ADe : Luis R. Rodriguez <mcgrof@g=
mail.com>=0A=C3=80 : Julien HENRY <henryju@yahoo.fr>=0ACc : linux-wireless@=
vger.kernel.org=0AEnvoy=C3=A9 le : Samedi, 1 Novembre 2008, 21h05mn 41s=0AO=
bjet : Re: Not associated with Intel 4965=0A=0AOn Sat, Nov 1, 2008 at 10:08=
 AM, Julien HENRY <henryju@yahoo.fr> wrote:=0A> Hi,=0A>=0A> I have big diff=
iculties to make my wifi working (stay Not-Associated). After the first ins=
tallation of my distrib, it worked fine, then after a few reboots it doesn'=
t work anymore. Yesterday I deleted all wifi and wpa configuration and afte=
r lot af try I managed to make it work again. I rebooted and it was still w=
orking. But today it doesn't work anymore.=0A>=0A> My config:=0A>=0A> lspci=
=0A> 03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or =
AGN Network Connection (rev 61)=0A>=0A> uname -r=0A> 2.6.27-desktop-0.rc8.2=
mnb=0A>=0A> distrib=0A> Mandriva 2008.0 64bit=0A>=0A> Microcode version was=
 iwlwifi-4965-ucode-228.57.1.21 but I upgraded to iwlwifi-4965-ucode-228.57=
.2.21 and rebooted but got same problem.=0A>=0A> My access point is configu=
red with WPA (TKIP + AES) and ESSID is not hidden.=0A>=0A> Here is the resu=
lt with a genuine configuration:=0A>=0A> 1) Just after boot (wlan0 is not c=
onfigured): messages1.txt=0A> 2) Just after configuring wlan0 using Mandriv=
a tool: messages2.txt=0A>=0A> At this point, we can see the problem:=0A>=0A=
> My access point is correctly listed:=0A>=0A> # iwlist wlan0 scanning=0A> =
...=0A> Cell 03 - Address: 1A:66:DE:7A:AE:DC=0A>                    ESSID:"=
MiddleEarth"=0A>                    Mode:Master=0A>                    Chan=
nel:7=0A>                    Frequency:2.442 GHz (Channel 7)=0A>           =
         Quality=3D100/100  Signal level:-17 dBm  Noise level=3D-127 dBm=0A=
>                    Encryption key:on=0A>                    IE: WPA Versi=
on 1=0A>                        Group Cipher : TKIP=0A>                    =
    Pairwise Ciphers (2) : TKIP CCMP=0A>                        Authenticat=
ion Suites (1) : PSK=0A>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 M=
b/s; 11 Mb/s; 6 Mb/s=0A>                              9 Mb/s; 12 Mb/s; 18 M=
b/s; 24 Mb/s; 36 Mb/s=0A>                              48 Mb/s; 54 Mb/s=0A>=
                    Extra:tsf=3D0000000833cdef72=0A>                    Ext=
ra: Last beacon: 899ms ago=0A> ...=0A>=0A> But can't manage to be associate=
d:=0A>=0A> # iwconfig=0A> lo        no wireless extensions.=0A>=0A> eth0   =
   no wireless extensions.=0A>=0A> wmaster0  no wireless extensions.=0A>=0A=
> wlan0     IEEE 802.11abgn  ESSID:"MiddleEarth"=0A>          Mode:Managed =
 Frequency:2.442 GHz  Access Point: Not-Associated=0A>          Tx-Power=3D=
15 dBm=0A>          Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B=
=0A>          Encryption key:3266-C437-9DA2-5422-18C3-2621-22BB-35D1-B24C-7=
E80-E99E-9850-AC21-4F8F-7779-18E3 [2]   Security mode:open=0A>          Pow=
er Management:off=0A>          Link Quality:0  Signal level:0  Noise level:=
0=0A>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0=0A>=
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0=0A>=0A>=
=0A> So I tried to use latest version of the driver (compat). Compilation a=
nd installation worked fine. But I couldn't manage to unload some modules w=
ith the script (I had to use rmmod):=0A>=0A> # make unload=0A> Unloading ma=
c80211...=0A> FATAL: Module mac80211 is in use.=0A> Unloading cfg80211...=
=0A> FATAL: Module cfg80211 is in use.=0A> make: *** [unload] Erreur 1=0A>=
=0A> # lsmod | grep iw=0A> iwlagn                104708  0=0A> iwlcore     =
           87620  1 iwlagn=0A> rfkill                 13988  3 iwlcore,thin=
kpad_acpi=0A> led_class               8456  2 iwlcore,thinkpad_acpi=0A> mac=
80211              178600  2 iwlagn,iwlcore=0A> cfg80211               3150=
4  3 iwlagn,iwlcore,mac80211=0A> # rmmod iwlagn=0A> # rmmod iwlcore=0A> # m=
ake unload=0A> Unloading mac80211...=0A=0AThanks I'll add these to the scri=
pt=0A=0A> Then I tried to load:=0A> # modprobe iwl4965=0A> WARNING: Error i=
nserting iwlcore (/lib/modules/2.6.27-desktop-0.rc8.2mnb/updates/drivers/ne=
t/wireless/iwlwifi/iwlcore.ko): Unknown symbol in module, or unknown parame=
ter (see dmesg)=0A=0AWe no longer have iwl4965, the new name is iwlagn, try=
 that.=0A=0A  Luis=0A=0A=0A=0A      
--0-666318808-1225572499=:58975
Content-Type: text/plain; name="messages4.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="messages4.txt"

Tm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGNmZzgwMjExOiBV
c2luZyBzdGF0aWMgcmVndWxhdG9yeSBkb21haW4gaW5mbwpOb3YgIDEgMjE6
Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogY2ZnODAyMTE6IFJlZ3VsYXRvcnkg
ZG9tYWluOiBKUApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDog
CShzdGFydF9mcmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2Fu
dGVubmFfZ2FpbiwgbWF4X2VpcnApCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1p
bmkga2VybmVsOiAJKDI0MDIwMDAgS0h6IC0gMjQ5NDAwMCBLSHogQCA0MDAw
MCBLSHopLCAoNjAwIG1CaSwgMjAwMCBtQm0pCk5vdiAgMSAyMTozNzo0NCBD
YXBnZW1pbmkga2VybmVsOiAJKDUxNjAwMDAgS0h6IC0gNTI1MDAwMCBLSHog
QCA0MDAwMCBLSHopLCAoNjAwIG1CaSwgMjAwMCBtQm0pCk5vdiAgMSAyMToz
Nzo0NCBDYXBnZW1pbmkga2VybmVsOiAJKDUyNTAwMDAgS0h6IC0gNTMzMDAw
MCBLSHogQCA0MDAwMCBLSHopLCAoNjAwIG1CaSwgMjAwMCBtQm0pCk5vdiAg
MSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBjZmc4MDIxMTogQ2FsbGlu
ZyBDUkRBIGZvciBjb3VudHJ5OiBKUApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2Vt
aW5pIGtlcm5lbDogaXdsY29yZTogVW5rbm93biBzeW1ib2wgaWVlZTgwMjEx
X2ZpbmRfc3RhCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBp
d2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9yeG9uX2FkZF9zdGF0aW9uCk5v
diAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25v
d24gc3ltYm9sIGl3bF9zY2FuX2NhbmNlbF90aW1lb3V0Ck5vdiAgMSAyMToz
Nzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9s
IGl3bF9yZmtpbGxfc2V0X2h3X3N0YXRlCk5vdiAgMSAyMTozNzo0NCBDYXBn
ZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZW5k
X3N0YXRpc3RpY3NfcmVxdWVzdApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5p
IGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfc2V0X2RlZmF1
bHRfd2VwX2tleQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDog
aXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfc2Nhbl9jYW5jZWwKTm92ICAx
IDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBz
eW1ib2wgaXdsX3JhdGVzCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2Vy
bmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9jaGFpbl9ub2lzZV9j
YWxpYnJhdGlvbgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDog
aXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfcmVtb3ZlX2R5bmFtaWNfa2V5
Ck5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVu
a25vd24gc3ltYm9sIGl3bF9nZXRfcmFfc3RhX2lkCk5vdiAgMSAyMTozNzo0
NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3
bF9yeF9yZXBseV9jb21wcmVzc2VkX2JhCk5vdiAgMSAyMTozNzo0NCBDYXBn
ZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF90eHFf
dXBkYXRlX3dyaXRlX3B0cgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtl
cm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfcmZraWxsX2luaXQK
Tm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5r
bm93biBzeW1ib2wgaXdsX2VlcHJvbV9mcmVlCk5vdiAgMSAyMTozNzo0NCBD
YXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9z
ZXRfcnhvbl9jaGFubmVsCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2Vy
bmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9jYWxpYl9zZXQKTm92
ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93
biBzeW1ib2wgaXdsX3Bvd2VyX3VwZGF0ZV9tb2RlCk5vdiAgMSAyMTozNzo0
NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3
bGNvcmVfZWVwcm9tX3JlbGVhc2Vfc2VtYXBob3JlCk5vdiAgMSAyMTozNzo0
NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3
bF9od190eHFfY3R4X2ZyZWUKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBr
ZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX2JjYXN0X2FkZHIK
Tm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5r
bm93biBzeW1ib2wgaXdsX2VlcHJvbV9pbml0Ck5vdiAgMSAyMTozNzo0NCBD
YXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9h
ZGRfc3RhdGlvbl9mbGFncwpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtl
cm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfcmFkaW9fa2lsbF9z
d19kaXNhYmxlX3JhZGlvCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2Vy
bmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZXRfcnhvbl9odApO
b3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtu
b3duIHN5bWJvbCBpd2xfdHhxX2N0eF9zdG9wCk5vdiAgMSAyMTozNzo0NCBD
YXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bGNv
cmVfZWVwcm9tX2FjcXVpcmVfc2VtYXBob3JlCk5vdiAgMSAyMTozNzo0NCBD
YXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9p
bml0X2RydgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXds
YWduOiBVbmtub3duIHN5bWJvbCBpd2xfdHhfY21kX2NvbXBsZXRlCk5vdiAg
MSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24g
c3ltYm9sIGl3bF9yeF9yZXBseV9yeF9waHkKTm92ICAxIDIxOjM3OjQ0IENh
cGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3Nl
dHVwX3J4X3NjYW5faGFuZGxlcnMKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWlu
aSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3NlbmRfY21k
X3BkdQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWdu
OiBVbmtub3duIHN5bWJvbCBpd2xfaW5pdF9zZW5zaXRpdml0eQpOb3YgIDEg
MjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5
bWJvbCBpd2xfcnhfcmVwbHlfcngKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWlu
aSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3Jlc2V0X3J1
bl90aW1lX2NhbGliCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVs
OiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZW5kX3N0YXRpY193ZXBr
ZXlfY21kCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xh
Z246IFVua25vd24gc3ltYm9sIGl3bF9jbGVhcl9zdGF0aW9uc190YWJsZQpO
b3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtu
b3duIHN5bWJvbCBpd2xfcmFkaW9fa2lsbF9zd19lbmFibGVfcmFkaW8KTm92
ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93
biBzeW1ib2wgaXdsX3J4X21pc3NlZF9iZWFjb25fbm90aWYKTm92ICAxIDIx
OjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1i
b2wgaXdsX3VuaW5pdF9kcnYKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBr
ZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX2VlcHJvbV9nZXRf
bWFjCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246
IFVua25vd24gc3ltYm9sIGl3bF9zZW5kX2xxX2NtZApOb3YgIDEgMjE6Mzc6
NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBp
d2xfcmZfa2lsbF9jdF9jb25maWcKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWlu
aSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX2VlcHJvbV9x
dWVyeTE2Ck5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xh
Z246IFVua25vd24gc3ltYm9sIGl3bF9yeF9xdWV1ZV9zcGFjZQpOb3YgIDEg
MjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5
bWJvbCBpd2xjb3JlX2VlcHJvbV9xdWVyeV9hZGRyCk5vdiAgMSAyMTozNzo0
NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGdl
dF9jbWRfc3RyaW5nCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVs
OiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZW5kX2FkZF9zdGEKTm92
ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93
biBzeW1ib2wgaXdsX3NlbnNpdGl2aXR5X2NhbGlicmF0aW9uCk5vdiAgMSAy
MTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3lt
Ym9sIGl3bF9yeF9hZ2dfc3RvcApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5p
IGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfc2VuZF9jYWxp
Yl9yZXN1bHRzCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBp
d2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9yeF9xdWV1ZV9mcmVlCk5vdiAg
MSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24g
c3ltYm9sIGl3bF92ZXJpZnlfdWNvZGUKTm92ICAxIDIxOjM3OjQ0IENhcGdl
bWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3NldF90
eF9wb3dlcgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXds
YWduOiBVbmtub3duIHN5bWJvbCBpd2xfcnhfc3RhdGlzdGljcwpOb3YgIDEg
MjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5
bWJvbCBpd2xfc2V0dXBfbWFjCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkg
a2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZW5kX2NtZApO
b3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtu
b3duIHN5bWJvbCBpd2xfdHhfc2tiCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1p
bmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF90eF9hZ2df
c3RhcnQKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFn
bjogVW5rbm93biBzeW1ib2wgaXdsX3R4X3F1ZXVlX3JlY2xhaW0KTm92ICAx
IDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBz
eW1ib2wgaXdsX2VlcHJvbV9jaGVja192ZXJzaW9uCk5vdiAgMSAyMTozNzo0
NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3
bF9nZXRfY2hhbm5lbF9pbmZvCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkg
a2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9zZXRfaHdfcGFy
YW1zCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246
IFVua25vd24gc3ltYm9sIGl3bF9yeF9yZXBsZW5pc2gKTm92ICAxIDIxOjM3
OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wg
aXdsX3NldHVwX3NjYW5fZGVmZXJyZWRfd29yawpOb3YgIDEgMjE6Mzc6NDQg
Q2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xf
aHdfbmljX2luaXQKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6
IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX2h3X2RldGVjdApOb3YgIDEg
MjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5
bWJvbCBpd2xfYWxsb2NfYWxsCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkg
a2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9yeF9hbGxvY2F0
ZQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBV
bmtub3duIHN5bWJvbCBpd2xfcG93ZXJfaW5pdGlhbGl6ZQpOb3YgIDEgMjE6
Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJv
bCBpd2xfc2VuZF9jbWRfc3luYwpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5p
IGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfaHdyYXRlX3Rv
X3BsY3BfaWR4Ck5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBp
d2xhZ246IFVua25vd24gc3ltYm9sIGl3bF9od3JhdGVfdG9fdHhfY29udHJv
bApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBV
bmtub3duIHN5bWJvbCBpd2xfcG93ZXJfc2V0X3VzZXJfbW9kZQpOb3YgIDEg
MjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5
bWJvbCBpd2xfbGVkc19yZWdpc3RlcgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2Vt
aW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfcmVtb3Zl
X2RlZmF1bHRfd2VwX2tleQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtl
cm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfc2VuZF9jbWRfcGR1
X2FzeW5jCk5vdiAgMSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xh
Z246IFVua25vd24gc3ltYm9sIGl3bF9yeF9xdWV1ZV9yZXN0b2NrCk5vdiAg
MSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24g
c3ltYm9sIGl3bF9yZmtpbGxfdW5yZWdpc3RlcgpOb3YgIDEgMjE6Mzc6NDQg
Q2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xf
ZWVwcm9tX3F1ZXJ5X2FkZHIKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBr
ZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX2xlZHNfdW5yZWdp
c3RlcgpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWdu
OiBVbmtub3duIHN5bWJvbCBpd2xfZmluZF9zdGF0aW9uCk5vdiAgMSAyMToz
Nzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9s
IGl3bF9zZXRfZHluYW1pY19rZXkKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWlu
aSBrZXJuZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3NjYW5faW5p
dGlhdGUKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3bGFn
bjogVW5rbm93biBzeW1ib2wgaXdsX3N0YV9tb2RpZnlfZW5hYmxlX3RpZF90
eApOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXdsYWduOiBV
bmtub3duIHN5bWJvbCBpd2xfdHhxX2NoZWNrX2VtcHR5Ck5vdiAgMSAyMToz
Nzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3ltYm9s
IGl3bF9yZXNldF9xb3MKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJu
ZWw6IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3J4X3F1ZXVlX3VwZGF0
ZV93cml0ZV9wdHIKTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6
IGl3bGFnbjogVW5rbm93biBzeW1ib2wgaXdsX3R4X2FnZ19zdG9wCk5vdiAg
MSAyMTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24g
c3ltYm9sIGl3bF9xdWV1ZV9zcGFjZQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2Vt
aW5pIGtlcm5lbDogaXdsYWduOiBVbmtub3duIHN5bWJvbCBpd2xfc2V0X3J4
b25fY2hhaW4KTm92ICAxIDIxOjM3OjQ0IENhcGdlbWluaSBrZXJuZWw6IGl3
bGFnbjogVW5rbm93biBzeW1ib2wgaXdsY29yZV9lZXByb21fdmVyaWZ5X3Np
Z25hdHVyZQpOb3YgIDEgMjE6Mzc6NDQgQ2FwZ2VtaW5pIGtlcm5lbDogaXds
YWduOiBVbmtub3duIHN5bWJvbCBpd2xfcnhfYWdnX3N0YXJ0Ck5vdiAgMSAy
MTozNzo0NCBDYXBnZW1pbmkga2VybmVsOiBpd2xhZ246IFVua25vd24gc3lt
Ym9sIGl3bF9yeHFfc3RvcAo=

--0-666318808-1225572499=:58975--
